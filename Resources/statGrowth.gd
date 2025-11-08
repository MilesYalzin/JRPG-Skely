extends Resource
class_name  StatGrowth

@export var originalStats : StatBlock:
	set(value):
		if value!=null:
			originalStats = value.duplicate(true)

@export var formulas : Dictionary = {
	"maxHP": {"flat": 5.0, "scale": 0.8, "curve": 2.0},
	"maxMP": {"flat": 2.0, "scale": 0.5, "curve": 1.8},
	"atk": {"flat": 2.0, "scale": 0.5, "curve": 1.8},
	"def": {"flat": 2.0, "scale": 0.5, "curve": 1.8},
	"mgk": {"flat": 2.0, "scale": 0.5, "curve": 1.8},
	"res": {"flat": 2.0, "scale": 0.5, "curve": 1.8},
	"spd": {"flat": 2.0, "scale": 0.5, "curve": 1.8}
}

const STAT_KEYS := ["maxHP","maxMP","atk","def","mgk","res","spd"]



func getFormula(stat: String):
	assert(formulas.has(stat), "Missing growth formula for stat: %s" % stat)
	return formulas[stat]

func evaluateStat(stat: String, level: int):
	var baseValue = originalStats.get(stat)
	var p = getFormula(stat)
	return baseValue + p["flat"] * (level - 1.0) + p["scale"] * pow(level, p["curve"])
	
func updateStats(target: StatBlock, level: int):
	for stat in STAT_KEYS:
		var value = evaluateStat(stat, level)
		target.set(stat, int(round(value)))
