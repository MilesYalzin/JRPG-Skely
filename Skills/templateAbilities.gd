extends Node
class_name Template

func checkWeak(raw, element, target):
	if target.data.weakTo.has(element):
		raw *= 2
	return raw

var templates = {
	
	"phys": func(caster, basePower, targets, _element = Skills.Elements.none, _ignore = 0.0, ):
		for t in targets:
			var dmg = (caster.data.baseStats.atk * basePower / (1+t.data.baseStats.def * (1.0-_ignore)/200)) * randf_range(0.95, 1.05)
			if _element != Skills.Elements.none:
				dmg = checkWeak(dmg,_element,t)
			dmg = int(dmg)
			t.data.baseStats.changeHP(dmg)

,

	"mag": func(caster, basePower, targets, _element = Skills.Elements.none, _ignore = 0.0, ):
		for t in targets:
			var dmg = (caster.data.baseStats.mgk * basePower / (1+t.data.baseStats.res * (1.0-_ignore)/200)) * randf_range(0.95, 1.05)
			if _element != Skills.Elements.none:
				dmg = checkWeak(dmg,_element,t)
			dmg = int(dmg)
			t.data.baseStats.changeHP(dmg)

,

	"heal": func(caster, basePower, targets, _element = Skills.Elements.none, _ignore = 0.0):
		for t in targets: 
			var dmg = (caster.data.baseStats.mgk * basePower) * randf_range(0.95, 1.05)
			#dmg = checkWeak(dmg, _element, t)
			dmg = int(dmg)
			t.data.baseStats.changeHP(-dmg)

}
