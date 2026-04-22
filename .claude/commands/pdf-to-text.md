---
allowed-tools:
  - Bash(curl:*)
argument-hint: <pdf-path>
description: Convert a PDF to markdown via the Box pdf-to-text utility
---

## Your task

Convert the PDF at `$1` to markdown using the Box pdf-to-text service. Write
the output alongside the source PDF with a `.md` extension.

Run:

```bash
curl -sk -X POST -H "Authorization: Bearer $BOX_API_KEY" \
  -F "file=@$1" \
  "https://utils.box.home.arpa/pdf-to-text" > "${1%.pdf}.md"
```

Then report the output path.
