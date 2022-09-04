#Importar dataset
df_tjt <-
  read.csv(
    "https://github.com/i3nriq/VIU_MineriadeDatos/blob/main/Data/DF_Data_depurada.csv?raw=true",
    encoding = "UTF-8"
  )


df_mcg <-
  read.csv(
    "https://github.com/i3nriq/VIU_MineriadeDatos/blob/main/Data/DS_Data_MCG.csv?raw=true"
  )


colnames(df_tjt)

names(df_tjt)[names(df_tjt) == "COMERCIO_CON_MAS_CONSUMO"] <-
  "Descripcion_MCG"


out <- merge(x = df_tjt,
             y = df_mcg,
             by = 'Descripcion_MCG',
             all.x = TRUE)

#Codificando el pagador de contado
out$PAGO_CONTADO = factor(out$PAGO_CONTADO,
                          levels = c("S", "N"),
                          labels = c(1, 0))

#Reordenar DataFrame
out <- out[, c(4, 5, 6, 7, 8, 9, 3)]


#Convertir tipo de datos para el escalado
out$COD_MCG = as.numeric(as.factor(out$COD_MCG))
out$METAL_TJT = as.numeric(as.factor(out$METAL_TJT))
out$ANIO_COSECHA = as.numeric(as.factor(out$ANIO_COSECHA))
out$COD_MORA = as.numeric(as.factor(out$COD_MORA))
out$PAGO_CONTADO = as.numeric(as.factor(out$PAGO_CONTADO))


#Dividir los datos en conjunto de entrenamiento y conjunto de test
#install.packages("caTools")
library(caTools)
set.seed(123)
split = sample.split(out$LIM_CREDITO, SplitRatio = 0.8)
training_set = subset(out, split == TRUE)
testing_set = subset(out, split == FALSE)

str(out)

# Escalado de valores
training_set[, 2:3] = scale(training_set[, 2:3])
testing_set[, 2:3] = scale(testing_set[, 2:3])


#Ajustar el modelo de Regresión Lineal Múltiple con el Conjunto de Entrenamiento
regression = lm(formula = LIM_CREDITO ~ .,
                data = training_set)

#Predecir los resultados con el conjunto de testing
y_pred = predict(regression, newdata = testing_set)

#Construir un modelo óptimo con la Eliminación hacia atrás
SL = 0.05

regression = lm(formula = LIM_CREDITO ~ .,
                data = dataset)
summary(regression)

