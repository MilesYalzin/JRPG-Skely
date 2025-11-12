extends Resource
class_name Skills

enum Targets {Enemies,Allies,Self,All}
enum Elements {none,fire,ice,metal,wood,earth}
enum DamageType {Physical, Magical, FixedDmg}
enum SkillType {Offensive,SupportBuff, SupportHeal, Debuff, StatCon}

#aesthetic elements
@export var id : String
@export var displayName: String
@export var icon: Texture2D
@export var description: String

#costs
#@export var costType
@export var cost: int
@export var tickCost: int 

#effect logic
@export var element : Elements = Elements.none
@export var skillType: SkillType = SkillType.Offensive
@export var basePower: float
@export var ignorePercent: float
@export var damageType : DamageType
@export var isAoE : bool
@export var accuracy: float
@export var statusCon : BattleStatus



#targeting
@export var defaultTarget:Targets
@export var validTargets:Targets

@export var battleOnly: bool

func executeAbility(caster, targets):

	caster.data.baseStats.changeTicks(-tickCost)
	caster.data.baseStats.changeMP(-cost)

	if randf() > accuracy:
		return

	#var fn = TemplateAbilities.templates.get(template)
	#fn.call(caster, basePower, [targets],element, ignorePercent)
	
	for t in targets:
		var dmg = matchFormula(caster,t)
		if element != Skills.Elements.none:
			dmg = checkWeak(dmg,element,t)
		dmg = int(dmg)
		t.data.baseStats.changeHP(dmg)

func matchFormula(caster, t):
	match damageType:
		DamageType.Physical:
			var _raw = (caster.data.baseStats.atk * basePower / (1+t.data.baseStats.def * (1.0 - ignorePercent)/200)) * randf_range(0.95, 1.05)
			return _raw
		DamageType.Magical:
			var _raw = (caster.data.baseStats.mag * basePower / (1+t.data.baseStats.res * (1.0 - ignorePercent)/200)) * randf_range(0.95, 1.05)
			return _raw

func checkWeak(raw, _element, target):
	if target.data.weakTo.has(_element):
		raw *= 2
	return raw
