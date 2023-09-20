### Created by Chloe Kwon (dk837@cornell.edu)
### 09-20-2023
### This script exports corpus transcriptions in JSON to CSV files.
### A new folder will be created in your current directory to save the CSV files. 
### Additionally, speaker meta data will be saved in your current directory as speakers.csv.
### Make sure to change fd_json to your local path to the JSON files before running.


import csv
import os
import sys
import json
import pandas as pd
import statistics as st
from read_json import json_extract

# # Optional - Change the current directory
# fd = '/Users/chloekwon/Desktop/korean_dialogue_dataset/scripts'
# os.chdir(fd)
# sys.path.append(fd)

fd_json = '/Users/chloekwon/Desktop/korean_dialogue_dataset/NIKL_DIALOGUE_2021_v1.0'
files_json = os.listdir(fd_json)

n_forms = []
dc_spk = {}

for file in files_json:
    if '.json' in file:
        pth_file = os.path.join(fd_json, file)
        filename = []
        id_audio = []
        form = []
        form_orig = []
        id_spk = []
        t0 = []
        t1 = []
        note = []
        with open(pth_file) as f:
            js = json.loads(f.read())
            fn = os.path.basename(pth_file).split('.')[0]

            doc = js['document'][0]
            meta = doc['metadata']
            meta_spk = meta['speaker']
            for s in meta_spk:
                dc_spk[s['id']] = s

            utt = doc['utterance']
            fr = json_extract(utt, "form")
            iad = json_extract(utt, "id")
            n_form = len(fr)

            form.extend(fr)
            n_forms.append(n_form)
            filename.extend([fn]*n_form)
            form_orig.extend(json_extract(utt, "original_form"))
            id_audio.extend(iad)
            id_spk.extend(json_extract(utt, "speaker_id"))
            t0.extend(json_extract(utt, "start"))
            t1.extend(json_extract(utt, "end"))
            note.extend(json_extract(utt, "note"))

        df = pd.DataFrame({
            'filename': filename,
            'id_audio': id_audio,
            'id_spk': id_spk,
            't0': t0,
            't1': t1,
            'form': form,
            'form_orig': form_orig,
            'note': note
        })
        df.to_csv('csv_files/' + fn + '.csv', index=False, encoding='utf-8-sig')

# Speaker info output to speakers.csv
ls_spk = []
field_names = []
for id_spk in dc_spk.keys():
    nested = dc_spk[id_spk]
    ls_spk.append(nested)
    if len(field_names) == 0:
        field_names.extend(list(nested.keys()))

with open('speakers.csv', 'w', encoding='utf-8-sig') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=field_names)
    writer.writeheader()
    writer.writerows(ls_spk)

# Total number of phrases
print('Total number of phrases:', sum(n_forms))
print('Average number of phrases per dialogue:', round(sum(n_forms)/len(n_forms),2))
print('Median number of phrases per dialogue:', st.median(n_forms))
print('Max number of phrases per dialogue:', max(n_forms))
print('Min number of phrases per dialogue:', min(n_forms))

print('10 percent:', round((sum(n_forms)*.1), 2))
print('5 percent:', round((sum(n_forms)*.05), 2))