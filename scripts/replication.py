import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 1. Load data from local directory
hh = pd.read_csv("data/pslm_hh_subset.csv")
person = pd.read_csv("data/pslm_person_subset.csv")

# 2. Merge household attributes by hhid
df = pd.merge(person, hh[['hhid', 'hhweight', 'prov_code', 'urban_rural']], on='hhid', how='inner')

# 3. Filter for Punjab Urban (prov_code == 2, urban_rural == 2), age 15-64, and earn_annual > 0
df_filtered = df[
    (df['prov_code'] == 2) & 
    (df['urban_rural'] == 2) & 
    (df['age'] >= 15) & 
    (df['age'] <= 64) & 
    (df['earn_annual'] > 0)
].copy()

# 4. Define age bands and midpoints
bins = [14, 19, 24, 29, 34, 39, 44, 49, 54, 59, 64]
labels = ['15-19', '20-24', '25-29', '30-34', '35-39', '40-44', '45-49', '50-54', '55-59', '60-64']
midpoints = [17, 22, 27, 32, 37, 42, 47, 52, 57, 62]

df_filtered['age_band'] = pd.cut(df_filtered['age'], bins=bins, labels=labels)

# 5. Calculate weighted mean per age band
band_summary = []
for label, midpoint in zip(labels, midpoints):
    sub = df_filtered[df_filtered['age_band'] == label]
    if len(sub) > 0:
        w_mean = np.sum(sub['earn_annual'] * sub['hhweight']) / np.sum(sub['hhweight'])
        band_summary.append({
            'band': label,
            'midpoint': midpoint,
            'weighted_mean': round(w_mean)
        })

summary_df = pd.DataFrame(band_summary)
print("--- Python Band Table ---")
print(summary_df)

# 6. Draw and save figure as SVG
fig, ax = plt.subplots(figsize=(8, 6))

np.random.seed(42)
jittered_age = df_filtered['age'] + np.random.uniform(-0.4, 0.4, size=len(df_filtered))
ax.scatter(jittered_age, df_filtered['earn_annual'], alpha=0.2, color='steelblue', edgecolors='none', s=15)

ax.plot(summary_df['midpoint'], summary_df['weighted_mean'], color='darkblue', linestyle='-', linewidth=1.5, label='Weighted Mean')
ax.scatter(summary_df['midpoint'], summary_df['weighted_mean'], color='darkblue', s=50, zorder=5)

ax.set_yscale('log')
ax.set_ylabel('Annual Earnings (PKR, Log Scale)')
ax.set_xlabel('Age')
ax.set_title('Age-Earnings Profile (Punjab Urban) - Python Replication')
plt.tight_layout()

# Save as SVG in figures folder
plt.savefig('figures/replication.svg', format='svg')
print("Figure successfully saved to figures/replication.svg")

