# Libraries laden
library(tidyverse)
library(geosphere)

# Environment leeren
rm(list = ls())

# Daten einlesen
konflikte <- read_rds("data_prep/konflikte.rds")
staudaemme <- read_rds("data_prep/staudaemme.rds")

# Konflikte in der Nähe von Staudämmen identifizieren
distance <- function(lat1, lon1, lat2, lon2) {
  distm(c(lon1, lat1), c(lon2, lat2), fun = distHaversine)
}

konflikte$in_der_naehe <- apply(konflikte, 1, function(row) {
  min(apply(staudaemme, 1, function(dam) {
    distance(row['lat'], row['lon'], dam['lat'], dam['lon'])
  })) < 50000
})

# Relevante Variablen auswählen
staudaemme <- staudaemme[, c("hoehe", "wassermenge", "lat", "lon")]
konflikte <- konflikte[, c("in_der_naehe", "anzahl_tote", "type_of_violence")]

# Neue Datenstruktur erstellen
analyse_data <- data.frame(
  hoehe = staudaemme$hoehe,
  wassermenge = staudaemme$wassermenge,
  konflikt = konflikte$in_der_naehe
)

# Logistische Regression durchführen
modell <- glm(konflikt ~ hoehe + wassermenge, data = analyse_data, family = binomial)
summary(modell)

# Konfidenzintervalle berechnen
confint(modell)
