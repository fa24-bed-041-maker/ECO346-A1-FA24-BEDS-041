library(tidyverse)
library(svglite)

# R ke bilkul default settings ke sath scatter plot draw karna aur save karna
svg("figures/default.svg")
print(
  ggplot(df_filtered, aes(x = age, y = earn_annual)) +
    geom_point()
)
dev.off()