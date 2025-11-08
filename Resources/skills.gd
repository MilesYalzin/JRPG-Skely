extends Resource
class_name Skills

enum Targets {Enemies,Allies,Self,All}
enum Elements {none,fire,ice,metal,wood,earth}


@export var id : String
@export var displayName: String
@export var icon: Texture2D
@export var description: String

@export var cost: int
@export var tickCost: int 

@export var element : Elements = Elements.none
@export var skillType: String
@export var basePower: float
@export var ignorePercent: float
@export var template: String
@export var isAoE : bool
@export var accuracy: float

@export var defaultTarget:Targets
@export var validTargets:Targets


@export var battleOnly: bool

func executeAbility(caster, targets):

	caster.data.baseStats.changeTicks(-tickCost)
	caster.data.baseStats.changeMP(-cost)

	if randf() > accuracy:
		return

	var fn = TemplateAbilities.templates.get(template)
	fn.call(caster, basePower, [targets],element, ignorePercent)
