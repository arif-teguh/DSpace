import pandas as pd
import pip

input_csv = input("Masukkan nama csv yang ingin diperiksa: (contoh: duplicate.csv)\n>>> ")
output_csv = input("Masukkan nama keluaran csv yang mengandung duplikasi (jika nanti ditemukan): (contoh: detected.csv)\n>>> ")

full_csv = pd.read_csv(input_csv)

duplicate_df_row = full_csv[full_csv.duplicated(['dc.title[en_US]'], keep=False)]
duplicate_df_row.sort_values(by=['dc.title[en_US]'], inplace=True)
duplicate_df_row.to_csv(output_csv, index=False)

print("\n\nTerdeteksi {} duplikasi. Silakan cek {}.".format(len(duplicate_df_row.index), output_csv))