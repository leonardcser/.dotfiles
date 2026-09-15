---
name: pdf-to-text
description: Convert a PDF to Markdown using the Box pdf-to-text service.
---

# PDF to text

Convert the PDF specified by the user to Markdown. Write the output alongside
the source PDF, replacing its `.pdf` extension with `.md`.

Run:

```bash
curl -sk -X POST -H "Authorization: Bearer $BOX_API_KEY" \
  -F "file=@<pdf-path>" \
  "https://utils.home.devleo.ch/pdf-to-text" > "<pdf-path-without-.pdf>.md"
```

Use the exact source and output paths in the command. Do not expose the API key.
Then report the output path.
