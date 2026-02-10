math.randomseed(os.time())

local function random_char(charset)
    local idx = math.random(1, #charset)
    return string.sub(charset, idx, idx)
end

local Agent = {}
Agent.__index = Agent

function Agent.new(scale, charset, genes)
    local self = setmetatable({}, Agent)
    self.charset = charset
    if genes then
        self.genes = genes
    else
        self.genes = {}
        for _ = 1, scale do
            table.insert(self.genes, random_char(charset))
        end
    end
    
    self.fitness = 0
    return self
end

function Agent:get_phrase()
    return table.concat(self.genes)
end

function Agent:calculer_fitness(target)
    local score = 0
    for i = 1, #self.genes do
        local target_char = string.sub(target, i, i)
        if self.genes[i] == target_char then
            score = score + 1
        end
    end
    self.fitness = (score / #target) ^ 2
end

function Agent:crossover(clone)
    local cutting = math.random(1, #self.genes)
    local new_genes = {}

    for i = 1, cutting do
        table.insert(new_genes, self.genes[i])
    end
    
    for i = cutting + 1, #clone.genes do
        table.insert(new_genes, clone.genes[i])
    end

    return Agent.new(#self.genes, self.charset, new_genes)
end

function Agent:mutation(rate)
    for i = 1, #self.genes do
        if math.random() < rate then
            self.genes[i] = random_char(self.charset)
        end
    end
end

return Agent