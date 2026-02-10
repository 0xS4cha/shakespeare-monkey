local Agent = require ("agent")

local TARGET <const> = "POST TENEBRAS LUX"
local POPULATION_MAX <const> = 200
local MUTATION_RATE <const> = 0.01
local CHARSET <const> = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "

local population = {}
local generation = 1
local found = false

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

    local new_population = {}
    
    table.insert(new_population, best)

    while #new_population < POPULATION_MAX do
        local parentA = pick_one(population, max_fitness_sum)
        local parentB = pick_one(population, max_fitness_sum)
        
        local child = parentA:crossover(parentB)
        child:mutation(MUTATION_RATE)
        
        table.insert(new_population, child)
    end

    population = new_population
    generation = generation + 1
end