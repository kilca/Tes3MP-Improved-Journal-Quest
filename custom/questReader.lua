-- Load up your custom scripts here! Ideally, your custom scripts will be placed in the scripts/custom folder and then get loaded like this:
--
-- require("custom/yourScript")
--
-- Refer to the Tutorial.md file for information on how to use various event and command hooks in your scripts.


QuestReader = {}
function QuestReader:new(filepath)
    local obj = {}
    obj.filepath = filepath
    obj.data = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function QuestReader:Load()
    -- Ouvre le fichier CSV en lecture
    local file = io.open(self.filepath, "r")

    -- Initialise une table pour stocker les données CSV
    self.data = {}

    -- Parcours chaque ligne du fichier
    for line in file:lines() do
        -- Divise la ligne en colonnes séparées par des tabulations
        local columns = {}
        for col in string.gmatch(line, "[^@]+") do
            table.insert(columns, col)
        end
        -- Ajoute les colonnes à la table de données
        table.insert(self.data, columns)
    end
    -- Ferme le fichier CSV
    file:close()
end

function QuestReader:Print()
    for i, row in ipairs(self.data) do
        for j, col in ipairs(row) do
          io.write(col .. "\t")
        end
        io.write("\n")
    end
end

function QuestReader:GetQuest(id1,id2)
    for i, row in ipairs(self.data) do
        if row[2] == id1 and row[4] == id2 then
            return {
                quest=row[2],
                text=row[3],
                id=row[4],
                q=row[7]
            }
        end
    end
    return{
        quest=id1,
        text=id1,
        id=id2,
        q="Not found"
    }
end

function QuestReader:GetQuestTitle(id1)
    for i, row in ipairs(self.data) do
        if row[2] == id1 and row[7] == "Q100" then
            return {
                quest=row[2],
                text=row[3],
                id=row[4],
                q=row[7]
            }
        end
    end
    return{
        quest=id1,
        text=id1,
        id=id2,
        q="Not found"
    }
end

function QuestReader:ToJournal(data)
    local result = {}
    for i, row in ipairs(data) do
        local quest = row.quest
        local index = row.index
        if result[quest] == nil then
            result[quest] = {}
        end
        table.insert(result[quest],self:GetQuest(quest,index))
    end
    return result
end

function QuestReader:FinishedQuests(journal)
    local result = {}
    for questname, quests in pairs(journal) do
        for questline, row in pairs(quests) do
            if (row.q == "Q010") then
                result[questname] = "finish"
            end
        end
    end
    return result
end


qr = QuestReader:new('J:/Work/Morrowind/testquest./journal.txt')
qr:Load()

return qr