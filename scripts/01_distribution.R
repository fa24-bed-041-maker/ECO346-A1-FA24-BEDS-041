library(tidyverse)
library(svglite)

# 1. Data load karein
person <- read.csv("data/pslm_person_subset.csv")
hh <- read.csv("data/pslm_hh_subset.csv")

# 2. Household data se weights aur region attach karein (Punjab urban ke liye prov_code = 2, urban_rural = 2)
hh_sub <- hh %>% select(hhid, hhweight, prov_code, urban_rural)
df <- person %>% inner_join(hh_sub, by = "hhid")

# 3. Variant Filter (Punjab Urban) aur sample filter (Age 15-64, earn_annual > 0)
df_filtered <- df %>%
  filter(prov_code == 2, urban_rural == 2, age >= 15, age <= 64, earn_annual > 0)

# 4. Log10 range (4.0 to 7.0) ke andar ke earners filter karein
df_dist <- df_filtered %>%
  mutate(log_earn = log10(earn_annual)) %>%
  filter(log_earn >= 4.0 & log_earn <= 7.0)

excluded_count <- nrow(df_filtered) - nrow(df_dist)
total_earners <- nrow(df_dist)

# Strict weighted quantile function
w_quantile <- function(x, w, p) {
  df_q <- data.frame(x = x, w = w) %>% arrange(x)
  df_q$cum_w <- cumsum(df_q$w) / sum(df_q$w)
  df_q$x[which(df_q$cum_w >= p)[1]]
}

# Statistics calculate karein
w_med <- w_quantile(df_dist$earn_annual, df_dist$hhweight, 0.5)
w_p10 <- w_quantile(df_dist$earn_annual, df_dist$hhweight, 0.1)
w_p90 <- w_quantile(df_dist$earn_annual, df_dist$hhweight, 0.9)
unw_med <- median(df_dist$earn_annual)
ratio_90_10 <- w_p90 / w_p10

print(paste("Total Earners:", total_earners))
print(paste("Weighted Median:", round(w_med)))
print(paste("Unweighted Median:", round(unw_med)))
print(paste("Weighted 10th Percentile:", round(w_p10)))
print(paste("Weighted 90th Percentile:", round(w_p90)))
print(paste("90/10 Ratio:", round(ratio_90_10, 2)))
print(paste("Excluded Count:", excluded_count))

# 5. Figure draw karke figures folder mein SVG save karein
svg("figures/distribution.svg", width = 8, height = 6)
ggplot(df_dist, aes(x = earn_annual, weight = hhweight)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 0.1, boundary = 4.0, fill = "steelblue", color = "white") +
  scale_x_log10(labels = scales::comma, breaks = c(10000, 100000, 1000000, 10000000)) +
  geom_vline(xintercept = w_med, linetype = "dashed", color = "red", linewidth = 1) +
  geom_vline(xintercept = w_p90, linetype = "dashed", color = "darkgreen", linewidth = 1) +
  annotate("text", x = w_med, y = 0.5, label = paste("Median:", round(w_med)), color = "red", angle = 90, vjust = -0.5) +
  annotate("text", x = w_p90, y = 0.5, label = paste("90th P:", round(w_p90)), color = "darkgreen", angle = 90, vjust = -0.5) +
  labs(
    title = "Annual earnings in Urban Punjab show heavy right-skewness",
    subtitle = sprintf("Excluded outside Rs 10k-10m range: %d earners", excluded_count),
    caption = "Source: PSLM 2019-20 | Sample: Earners aged 15-64 in Urban Punjab | Weighted by hhweight",
    x = "Annual Earnings (PKR, log scale)",
    y = "Density per log10 unit"
  ) +
  theme_minimal()
dev.off()