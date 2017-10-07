library(simmer)
library(parallel)

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

envs <- mclapply(1:1000, function(i) {
  simmer("SuperDuperSim") %>%
    add_resource("nurse", 1) %>%
    add_resource("doctor", 2) %>%
    add_resource("administration", 1) %>%
    add_generator("patient", patient, function() rnorm(1, 10, 2)) %>%
    run(540) %>%
    wrap()
})


#Visualuzar so dados em paralelos
library(simmer.plot)
plot(envs, what = "resources", metric = "utilization", c("nurse", "doctor","administration"))

plot(envs, what = "resources", metric = "usage", c("nurse", "doctor"), items = "server")

plot(envs[[6]], what = "resources", metric = "usage", "doctor", items = "server", steps = TRUE)

plot(envs, what = "arrivals", metric = "flow_time")

