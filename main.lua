local Agent <const> = require ("agent")

local function pick_one(population, max_fitness_sum)
    local index = 0
    local r = math.random() * max_fitness_sum
  
    while r > 0 do
      index = index + 1
      r = r - population[index].fitness
    end
    index = math.max(1, index)
    return population[index]
  end

function main()
    io.write('Target text ? ')

    local TARGET <const> = io.read()
    local POPULATION_MAX <const> = 200
    local MUTATION_RATE <const> = 0.01
    local CHARSET <const> = {
        "A","B","C","D","E","F","G","H","I","J",
        "K","L","M","N","O","P","Q","R","S","T",
        "U","V","W","X","Y","Z",
        "a","b","c","d","e","f","g","h","i","j",
        "k","l","m","n","o","p","q","r","s","t",
        "u","v","w","x","y","z",
        "0","1","2","3","4","5","6","7","8","9",
        " ",
        ".",",",";","!", "?",
        ":","'","\"","-","_",
        "(",")","[","]",
        "/","\\","@","#",
        "+","*","=","<",">",
        "é","è","ê","ë",
        "à","â",
        "î","ï",
        "ô",
        "ù","û","ü",
        "ç",
        "É","È","Ê","Ë",
        "À","Â",
        "Î","Ï",
        "Ô",
        "Ù","Û","Ü",
        "Ç",
      }

    local population = {}
    local new_population = {}
    local generation = 1
    local found = false

    for _ = 1, POPULATION_MAX do
        table.insert(population, Agent.new(#TARGET, CHARSET))
    end

    while not found do
        local max_fitness_sum = 0
        for _, agent in ipairs(population) do
            agent:calculer_fitness(TARGET)
            max_fitness_sum = max_fitness_sum + agent.fitness
        end

        table.sort(population, function(a, b) return a.fitness > b.fitness end)
        
        local best = population[1]
        print(string.format("Gen %d | Best: %s | Fitness: %.4f", generation, best:get_phrase(), best.fitness))

        if best:get_phrase() == TARGET then
            found = true
            break
        end

        for i = 1, #new_population do
            new_population[i] = nil
        end
        new_population[1] = best

        while #new_population < POPULATION_MAX do
          local parentA = pick_one(population, max_fitness_sum)
          local parentB = pick_one(population, max_fitness_sum)
      
          local child = parentA:crossover(parentB)
          child:mutation(MUTATION_RATE)
      
          new_population[#new_population + 1] = child
        end
      
        population, new_population = new_population, population
        generation = generation + 1
    end
end



if arg and debug.getinfo(1).source:sub(2) == arg[0] then
    main()
end