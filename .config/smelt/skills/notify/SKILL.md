---
name: notify
description: Send an iPhone push notification through Bark. Load only when the user asks for it.
---

# Notify

Only when the user asks. Send:

```bash
curl -fsS -X POST http://bark.home.devleo.ch:8088/notify \
  -d '{"title":"<title>","body":"<body>"}'
```

Optional: `"level"` (`active`, `timeSensitive`, `passive`, `critical`), `group`,
`sound`, `url`. Report any error.
