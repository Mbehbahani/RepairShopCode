import zipfile
import xml.etree.ElementTree as ET
from pathlib import Path

# Namespace used in the XML files of XLSX
NS = {'m': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}


def _load_cells(xlsx_path):
    """Load all cells from the first worksheet of an XLSX file."""
    with zipfile.ZipFile(xlsx_path) as z:
        # read shared strings
        with z.open('xl/sharedStrings.xml') as f:
            shared = ET.parse(f).getroot()
            shared_strings = [t.text for t in shared.findall('.//m:t', NS)]
        # read sheet1
        with z.open('xl/worksheets/sheet1.xml') as f:
            sheet = ET.parse(f).getroot()
        cells = {}
        for c in sheet.findall('.//m:sheetData/m:row/m:c', NS):
            coord = c.attrib['r']
            t = c.attrib.get('t')
            v = c.find('m:v', NS)
            if v is None:
                continue
            value = v.text
            if t == 's':
                value = shared_strings[int(value)]
            cells[coord] = value
    return cells


def read_data(xlsx_path: str | Path):
    """Read parameters from the Excel file following the layout used in GAMS."""
    xlsx_path = Path(xlsx_path)
    cells = _load_cells(xlsx_path)

    # Sets sizes
    r = range(1, 5)  # 1..4
    c = range(1, 7)  # 1..6
    j = range(1, 5)  # 1..4

    def get(cell):
        return cells.get(cell)

    # Parameter T(r)  -> columns T,U starting row 38
    T = {ri: float(get(f'T{38 + ri - 1}')) for ri in r}
    # Parameter I(r)  -> columns Q,R starting row 38
    I = {ri: float(get(f'R{38 + ri - 1}')) for ri in r}
    # Parameter ST(r) -> columns X,Y starting row 38
    ST = {ri: float(get(f'Y{38 + ri - 1}')) for ri in r}

    # Parameter e(c,j,r) from table with row index starting at 38
    e = {}
    for ci in c:
        for ji in j:
            row = 37 + (ci - 1) * len(j) + ji
            for ri in r:
                col = chr(ord('K') + ri - 1)  # K,L,M,N
                key = (ci, ji, ri)
                value = get(f'{col}{row}')
                e[key] = float(value)

    # Parameter d(c,j) from table starting row 65
    d = {}
    for ci in c:
        row = 64 + ci
        for ji in j:
            col = chr(ord('J') + ji - 1)  # J..M
            d[(ci, ji)] = float(get(f'{col}{row}'))

    return {
        'T': T,
        'I': I,
        'ST': ST,
        'e': e,
        'd': d,
    }


if __name__ == '__main__':
    data = read_data(Path(__file__).with_name('schedule.xlsx'))
    for name, value in data.items():
        print(name, value)
