# http://r-simmer.org/articles/simmer-01-introduction.html

library(simmer)

env <- simmer("SuperDuperSim")
env

# define o caminho nurse, doctor, administration
patient <- trajectory("patients' path") %>%
 
  ## add an intake activity 
  seize("nurse", 1) %>%
  timeout(function() rnorm(1, 15)) %>%
  release("nurse", 1) %>%

  ## add a consultation activity
  seize("doctor", 1) %>%
  timeout(function() rnorm(1, 20)) %>%
  release("doctor", 1) %>%
  
  ## add a planning activity
  seize("administration", 1) %>%
  timeout(function() rnorm(1, 5)) %>%
  release("administration", 1)

# Adicionando recursos a nosso caminho
env %>%
  add_resource("nurse", 1) %>%
  add_resource("doctor", 2) %>%
  add_resource("administration", 1) %>%
  add_generator("patient", patient, function() rnorm(1, 10, 2))

# Rodar a simulação sempre resetando o ambiente
env %>% 
  reset() %>% 
  run(until=80) %>%
  now()

# Replicar a simulação 
envs <- lapply(1:100, function(i) {
  simmer("SuperDuperSim") %>%
    add_resource("nurse", 1) %>%
    add_resource("doctor", 2) %>%
    add_resource("administration", 1) %>%
    add_generator("patient", patient, function() rnorm(1, 10, 2)) %>%
    run(80)
})
