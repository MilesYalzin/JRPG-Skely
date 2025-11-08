extends Node

var chests = {}
var quests = {}
var cutscenes = {}

func setChestOpen(chestID : String):
	chests[chestID] = true

func isChestOpen(chestID : String):
	return chests.get(chestID, false)

func startQuest(questName : String):
	quests[questName] = {"step": 0, "completed": false}
	
func advanceQuest(questName : String):
	if quests.has(questName):
		quests[questName]["step"] += 1
		
func completeQuest(questName: String):
	if quests.has(questName):
		quests[questName]["completed"] = true

func getQuestStep(questName : String):
	return quests.get(questName, {"step": 0})["step"]

func checkQuestCompletion(questName : String):
		return quests.get(questName, {"completed": false})["completed"]
		
func setCutscene(cutscnID : String):
	cutscenes[cutscnID] = true
	
func hasCutscenePlayed(cutscnID : String):
	return cutscenes.get(cutscnID, false)
