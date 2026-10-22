library(tidyverse)
library(svglite)

# 1. Age bands define karna (10 bands, 5 years wide)
breaks_vec <- seq(14, 64, by = 5)
labels_vec <- c("15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64")
midpoints <- c(17, 22, 27, 32, 37, 42, 47, 52, 57, 62)

# 2. Data filtering aur age band assignment (df_filtered pehle se environment mein hai)
df_filtered$age_band <- cut(df_filtered$age, breaks = breaks_vec, labels = labels_vec)
df_filtered$midpoint <- midpoints[as.numeric(df_filtered$age_band)]

# 3. Band-wise summary (unweighted count aur weighted mean)
band_summary <- df_filtered %>%
  group_by(age_band, midpoint) %>%
  summarise(
    n_unweighted = n(),
    weighted_mean = sum(earn_annual * hhweight) / sum(hhweight),
    .groups = 'drop'
  ) %>%
  mutate(thin = n_unweighted < 30)

# Console par band table print karwana (yeh README mein likhna hai)
print(band_summary)

# Highest weighted mean wala band find karna
highest_band <- band_summary %>% filter(weighted_mean == max(weighted_mean))
print(paste("Highest Earnings Band:", highest_band$age_band, "with mean:", round(highest_band$weighted_mean)))

# 4. Figure draw karke figures folder mein SVG save karna
svg("figures/relationship.svg", width = 8, height = 6)
ggplot() +
  # Jittered scatter points for all earners
  geom_jitter(data = df_filtered, aes(x = age, y = earn_annual), alpha = 0.2, width = 0.4, height = 0, color = "gray60") +
  # Weighted mean line and markers
  geom_line(data = band_summary, aes(x = midpoint, y = weighted_mean), color = "blue", linewidth = 1) +
  geom_point(data = band_summary, aes(x = midpoint, y = weighted_mean, shape = thin), size = 3, fill = "blue", color = "blue") +
  scale_shape_manual(values = c(`FALSE` = 19, `TRUE` = 21)) + # Solid for normal, hollow for thin bands (<30 obs)
  scale_y_log10(labels = scales::comma, limits = c(10000, 10000000)) +
  scale_x_continuous(breaks = seq(15, 60, by = 5)) +
  annotate("text", x = highest_band$midpoint, y = highest_band$weighted_mean * 1.2, 
           label = paste("Peak:", highest_band$age_band), color = "darkblue", fontface = "bold") +
  labs(
    title = "Earnings rise through prime working age before declining near retirement",
    caption = "Source: PSLM 2019-20 | Sample: Earners aged 15-64 in Urban Punjab | Weighted by hhweight | Hollow markers = thin bands (<30 obs)",
    x = "Age",
    y = "Annual Earnings (PKR, log scale)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")
dev.off()
