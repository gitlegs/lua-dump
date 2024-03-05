local fs = require('fs')
local json = require('json')

local config do
    local fd = fs.openSync('config.json', 'r')
    local jsonConfig = fs.readSync(fd)
    config = json.parse(jsonConfig)
    fs.close(fd)
end

print('welcome to hangman')

local word = string.upper(config.wordbank[math.random(#config.wordbank)] or 'default word')

print('ready to play?')
do 
    io.read()
end

print('guessing a word..')
print('word guessed\n')

local progress = '' do
    for i in word:gmatch('.') do
        if i == ' ' then
            progress = progress..'/'
        else
            progress = progress..'_'
        end
    end
end

local attempt, maxAttempts = 0, config.maxAttempts

local guesses = {}

local function search(t, any)
    for _, v in pairs(t) do
        if v == any then
            return true
        end
    end
    return false
end

while progress:gsub('/', ' ') ~= word and attempt < maxAttempts do
    print('\nword:', progress)
    io.write('make a guess: ')
    local guess = string.upper(io.read())

    if guess:len() == 1 and guess:match('%a') then
        if not search(guesses, guess) then
            table.insert(guesses, guess)
            if word:find(guess) then
                local lastInt = word:find(guess)
                local finds = 0
                while lastInt do
                    finds = finds + 1
                    progress = (progress:sub(1, lastInt-1)..guess..progress:sub(lastInt+1, -1))
                    lastInt = word:find(guess, lastInt+1)
                end
                print('correctly guessed: ', guess, '\nfind count: ', finds)
            else
                attempt = attempt+1
                print('failed attempt: ', attempt)
            end
        else
            print('already guessed: ', guess)
        end
    else
        print('invalid guess, guess needs to be one character and an alphabetical character')
    end
end

print('\n')
if progress:gsub('/', ' ') == word then
    print('word: ', word)
    print('congrats on guessing the full word!')
else
    print('unlucky! didnt get the word in under the max attempts:', maxAttempts)
    print('progress: ', progress, tostring(math.floor((progress:gsub('%A+', ''):len()/word:len())*100))..'%')
    print('word: ', word)
end