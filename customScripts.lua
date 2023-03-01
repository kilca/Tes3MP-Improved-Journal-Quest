-- Load up your custom scripts here! Ideally, your custom scripts will be placed in the scripts/custom folder and then get loaded like this:
--
-- require("custom/yourScript")
--
-- Refer to the Tutorial.md file for information on how to use various event and command hooks in your scripts.
ch = require("customCommandHooks")
qr = require ("custom/questReader")

function onJournalCommand(pid, cmd)
    local journals = {}
    print("loading current journal")
    for i = 0, tes3mp.GetJournalChangesSize(pid) - 1 do
        local journalItem = {
            type = tes3mp.GetJournalItemType(pid, i),
            index = string.format("%s.0",tostring(tes3mp.GetJournalItemIndex(pid, i))),
            quest = tostring(tes3mp.GetJournalItemQuest(pid, i)),
        }
        table.insert(journals,journalItem)
    end
    print("converting journal")

    local journal = qr:ToJournal(journals)
    local finishedQuests = qr:FinishedQuests(journal)

    local journalPage = 1
    local journalPageName = "advanced journal1"
    local i =0
    Players[pid].currentCustomMenu = journalPageName

    size = 0
    for _ in pairs(journal) do
        size = size + 1 
    end

    for questname, quests in pairs(journal) do
        if (i%20 == 0) then
            journalPage = math.ceil(i/20) -- 1-20 = 1
            journalPageName = string.format("%s%d","advanced journal",journalPage)
            Menus[journalPageName]= {
                text={color.Orange .. "Journal Page : " .. journalPage},
                buttons={}
            }
            if (journalPage > 1) then
                table.insert(Menus[journalPageName]["buttons"],{
                    caption={color.Azure .. "Previous"},
                    destinations={menuHelper.destinations.setDefault(string.format("%s%d","advanced journal",journalPage-1))}
                })
            end
            if (math.ceil(size/20) > journalPage) then
                table.insert(Menus[journalPageName]["buttons"],{
                    caption={color.Azure .. "Next"},
                    destinations={menuHelper.destinations.setDefault(string.format("%s%d","advanced journal",journalPage+1))}
                })
            end
        end
        -- On ajoute le bouton linkant vers la quete
        local preColor = color.Yellow
        if (finishedQuests[questname] == "finish") then
            preColor = color.Green
        end
        local questLabel = qr:GetQuestTitle(questname).text;
        table.insert(Menus[journalPageName]["buttons"],1,{
            caption={preColor .. questLabel},
            destinations={menuHelper.destinations.setDefault(questname)}
        })
        local text = {color.Orange .. questLabel .. "\n" .. color.FloralWhite}
        for questline, row in pairs(quests) do
            table.insert(text,row.text .. "\n" .. "\n")
            -- print(row.text)
        end
        Menus[questname]={
            text = text,
            buttons = {
                { caption = "Back", destinations = { menuHelper.destinations.setFromCustomVariable("previousCustomMenu") } },
                { caption = "Exit", destinations = nil }
            }
        }
        i = i+1
    end
    menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)

end

ch.registerCommand("journal", onJournalCommand)