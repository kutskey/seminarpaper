# Libraries laden
library(geosphere)

# Daten einlesen
staudaemme <- read.csv("staudaemme.csv")
konflikte <- read.csv("konflikte.csv")

# Konflikte in der Nähe von Staudämmen identifizieren
distance <- function(lat1, lon1, lat2, lon2) {
  distm(c(lon1, lat1), c(lon2, lat2), fun = distHaversine)
}

konflikte$in_der_naehe <- apply(konflikte, 1, function(row) {
  min(apply(staudaemme, 1, function(dam) {
    distance(row['latittude'], row['longitude'], dam['latitude'], dam['longitude'])
  })) < 50000
})

# Relevante Variablen auswählen
staudaemme <- staudaemme[, c("hoehe", "wassermenge", "latitude", "longitude")]
konflikte <- konflikte[, c("in_der_naehe", "anzahl_tote", "dauer", "partei1", "partei2")]

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
