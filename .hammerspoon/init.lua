function reload_config(files)
	hs.reload()
end
hs.pathwatcher.new(hs.configdir, reload_config):start()
hs.alert.show("Config Re-loaded")

hs.window.animationDuration = 0

hs.loadSpoon("Vifari")
spoon.Vifari:start()
