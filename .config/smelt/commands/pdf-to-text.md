---
description: Convert a PDF to markdown via the Box pdf-to-text utility
bash:
  allow: ["curl *"]
---

## Your task

Convert the PDF to markdown using the Box pdf-to-text service. Write the output
alongside the source PDF with a `.md` extension.

Run:

```bash
curl -sk -X POST -H "Authorization: Bearer $BOX_API_KEY" \
  -F "file=@<file.pdf>" \
  "https://utils.box.home.arpa/pdf-to-text" > "<file>.md"
```

Then report the output path.
