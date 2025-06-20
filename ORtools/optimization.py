from __future__ import annotations
from pathlib import Path

from ortools.linear_solver import pywraplp

from .data_reader import read_data


def solve_model(data: dict[str, dict], objective: str):
    solver = pywraplp.Solver.CreateSolver('CBC')
    if solver is None:
        raise RuntimeError('CBC solver unavailable')
    M = 2000

    r = sorted(data['T'].keys())
    c = sorted({k[0] for k in data['d']})
    j = sorted({k[1] for k in data['d']})

    # Variables
    a = {(ci, ji, ri): solver.IntVar(0, 1, f'a_{ci}_{ji}_{ri}')
         for ci in c for ji in j for ri in r}
    x = {(cc, jj, ci, ji, ri): solver.IntVar(0, 1, f'x_{cc}_{jj}_{ci}_{ji}_{ri}')
         for cc in c for ci in c if ci != cc for jj in j for ji in j for ri in r}
    Fx = {(ci, ji, ri): solver.IntVar(0, 1, f'Fx_{ci}_{ji}_{ri}')
          for ci in c for ji in j for ri in r}
    v = {(ci, jj, ji): solver.IntVar(0, 1, f'v_{ci}_{jj}_{ji}')
         for ci in c for jj in j for ji in j if ji != jj}
    Fv = {(ci, ji): solver.IntVar(0, 1, f'Fv_{ci}_{ji}')
          for ci in c for ji in j}
    f = {(ci, ji): solver.NumVar(0, solver.infinity(), f'f_{ci}_{ji}')
         for ci in c for ji in j}
    Ov = {ri: solver.NumVar(0, solver.infinity(), f'Ov_{ri}') for ri in r}
    Id = {ri: solver.NumVar(0, solver.infinity(), f'Id_{ri}') for ri in r}
    Ct = {ci: solver.NumVar(0, solver.infinity(), f'Ct_{ci}') for ci in c}

    # co1: a <= e
    for ci in c:
        for ji in j:
            for ri in r:
                solver.Add(a[ci, ji, ri] <= data['e'][ci, ji, ri])

    # co2: link a and Fx/x
    for ci in c:
        for ji in j:
            for ri in r:
                solver.Add(
                    a[ci, ji, ri] == Fx[ci, ji, ri] +
                    solver.Sum(x[cc, jj, ci, ji, ri]
                               for cc in c if cc != ci for jj in j)
                )

    # co3
    for ci in c:
        for ji in j:
            solver.Add(
                solver.Sum(a[ci, ji, ri] for ri in r) ==
                Fv[ci, ji] + solver.Sum(v[ci, jj, ji] for jj in j if jj != ji)
            )

    # co4
    for ci in c:
        for ji in j:
            for cc in c:
                if cc == ci:
                    continue
                for jj in j:
                    for ri in r:
                        solver.Add(
                            f[ci, ji] >= data['d'][ci, ji] + f[cc, jj] +
                            (x[cc, jj, ci, ji, ri] - 1) * M
                        )

    # co5
    for ci in c:
        for ji in j:
            for ri in r:
                solver.Add(
                    f[ci, ji] >= data['d'][ci, ji] + (Fx[ci, ji, ri] - 1) * M
                )

    # co6
    for ci in c:
        for ji in j:
            for jj in j:
                if jj == ji:
                    continue
                solver.Add(
                    f[ci, ji] >= data['d'][ci, ji] + f[ci, jj] + (v[ci, jj, ji] - 1) * M
                )

    # co7
    for ci in c:
        for ji in j:
            for ri in r:
                solver.Add(
                    Ov[ri] >= f[ci, ji] + (a[ci, ji, ri] - 1) * M - data['ST'][ri]
                )

    # co8
    for ri in r:
        solver.Add(
            Id[ri] >= data['ST'][ri] + Ov[ri] -
            solver.Sum(a[ci, ji, ri] * data['d'][ci, ji] for ci in c for ji in j)
        )

    # co9
    for ci in c:
        for ji in j:
            solver.Add(solver.Sum(a[ci, ji, ri] for ri in r) == 1)

    # co10
    for ri in r:
        solver.Add(solver.Sum(Fx[ci, ji, ri] for ci in c for ji in j) == 1)

    # co11
    for ci in c:
        solver.Add(solver.Sum(Fv[ci, ji] for ji in j) == 1)

    # co12
    for ri in r:
        for cc in c:
            for jj in j:
                solver.Add(
                    solver.Sum(x[cc, jj, ci, ji, ri] for ci in c if ci != cc for ji in j) <= a[cc, jj, ri]
                )

    # co13
    for ci in c:
        for jj in j:
            solver.Add(solver.Sum(v[ci, jj, ji] for ji in j if ji != jj) <= 1)

    if objective == 'completion':
        # co14
        for ci in c:
            for ji in j:
                for jj in j:
                    solver.Add(
                        Ct[ci] >= f[ci, ji] - f[ci, jj] + data['d'][ci, jj] + (Fv[ci, jj] - 1) * M
                    )
        # co15
        for ri in r:
            solver.Add(Ov[ri] <= 180)
        obj = solver.Sum(Ct[ci] for ci in c)
    else:
        # idle objective
        for ri in r:
            solver.Add(Ov[ri] <= 180)
        obj = solver.Sum(data['T'][ri] * Ov[ri] + data['I'][ri] * Id[ri] for ri in r)

    solver.Minimize(obj)
    status = solver.Solve()
    return solver, status, obj


def main():
    data = read_data(Path(__file__).with_name('schedule.xlsx'))
    for name in ('idle', 'completion'):
        solver, status, obj = solve_model(data, name)
        if status == pywraplp.Solver.OPTIMAL:
            print(f'{name} objective value:', obj.Value())
        else:
            print(f'{name} solve status:', status)


if __name__ == '__main__':
    main()
