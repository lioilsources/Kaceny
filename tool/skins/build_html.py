"""Build the skin curation sheet from page_template.html.

out/index.html opens straight from disk and keeps picks in localStorage;
out/artifact.html is the same page for publishing as a claude.ai Artifact,
where picks are also saved per person to the artifact's shared db
(collection `picks`, one doc per viewer) so the team's votes add up.
"""

import html
import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE / "out"
PLAN = HERE.parents[1] / "Prompts" / "01-MONETIZATION.md"


def md_to_html(md):
    """Just enough markdown for the plan: headings, lists, tables, bold, paragraphs."""
    out, in_list, table = [], False, []

    def inline(s):
        s = html.escape(s)
        s = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", s)
        return re.sub(r"`(.+?)`", r"<code>\1</code>", s)

    def flush_table():
        if not table:
            return
        rows = [r for r in table if not re.match(r"^\|[\s:-|]+\|$", r)]
        cells = [[c.strip() for c in r.strip("|").split("|")] for r in rows]
        out.append("<div class=\"tw\"><table><tr>" + "".join(f"<th>{inline(c)}</th>" for c in cells[0]) + "</tr>"
                   + "".join("<tr>" + "".join(f"<td>{inline(c)}</td>" for c in r) + "</tr>" for r in cells[1:])
                   + "</table></div>")
        table.clear()

    for line in md.splitlines():
        if line.startswith("|"):
            table.append(line)
            continue
        flush_table()
        if in_list and not line.startswith(("- ", "  ")):
            out.append("</ul>")
            in_list = False
        if m := re.match(r"^(#{1,3}) (.*)", line):
            lvl = len(m.group(1)) + 1
            out.append(f"<h{lvl}>{inline(m.group(2))}</h{lvl}>")
        elif line.startswith("- "):
            if not in_list:
                out.append("<ul>")
                in_list = True
            out.append(f"<li>{inline(line[2:])}</li>")
        elif line.strip():
            out.append(f"<p>{inline(line)}</p>")
    flush_table()
    if in_list:
        out.append("</ul>")
    return "\n".join(out)


def main():
    manifest = json.loads((OUT / "manifest.json").read_text())
    plan = md_to_html(PLAN.read_text()) if PLAN.exists() else "<p>Plán chybí.</p>"
    page = ((HERE / "page_template.html").read_text()
            .replace("__MANIFEST__", json.dumps(manifest, ensure_ascii=False).replace("</", "<\\/"))
            .replace("__PLAN__", json.dumps(plan, ensure_ascii=False).replace("</", "<\\/")))
    # artifact.html is published as-is (the Artifact tool adds the document skeleton);
    # index.html wraps it for opening straight from disk.
    (OUT / "artifact.html").write_text(page)
    (OUT / "index.html").write_text(
        '<!doctype html><html lang="cs"><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">'
        "</head><body>" + page + "</body></html>")
    print(f"wrote {OUT / 'index.html'} and {OUT / 'artifact.html'}")


if __name__ == "__main__":
    main()
