# Faz a leitura da planilha/catálogo csv minerado e ajustado (salvo no sharepoint)
# faz a leitura das colunas application e domain, remove o que for duplicado
# cria arquivos application-domain.json com o search_key igual ao valor da tag 'application'
# cria o csv das colunas application e domain apenas com valores únicos

import csv
import json
import os

def process_csv_file(input_file, output_file, output_json_file):
    '''
    :param input_file: csv da minareação (no sharepoint)
    :param output_file: csv
    :param output_json_file:  application-domain.json
    :return:
    '''
    data = read_csv(input_file)
    unique_rows = get_unique_pairs(data)
    sorted_pairs = sort_pairs_alphabetically(unique_rows)
    write_to_output(output_file, sorted_pairs)
    write_to_output_json(output_json_file, sorted_pairs)

def sort_pairs_alphabetically(data):
    return sorted(data, key=lambda x: (x[0], x[1]))

def read_csv(input_file):
    with open(input_file, 'r', newline='', encoding='utf-8', errors='replace') as file:
        reader = csv.DictReader(file, delimiter=',')
        data = list(reader)
    return data

def get_unique_pairs(data):
    '''
    Busca as colunas application, domain, shared e env
    :param data:
    :param app_column:
    :param domain_column:
    :return:
    '''
    rows = set()
    for row in data:
        # search_key = row.get('arn')
        app = row.get('application', '').strip().lower()
        domain = row.get('domain', '').strip().lower()
        shared = row.get('shared', '').strip().lower()
        env = row.get('env', '')

        if app not in rows:
            tag_row = (app, domain, shared, env)
            rows.add(tag_row)

    return list(rows)


def write_to_output(output_file, data):
    header = ['application', 'domain', 'shared', 'env']
    with open(output_file, 'a', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        if os.path.getsize(output_file) == 0:
            writer.writerow(header)
        for pair in data:
            writer.writerow(pair)

def write_to_output_json(output_file, data):
    json_objects = []
    n = 1
    for items in data:
        app, domain, shared, env = items
        search_key = app

        if "teste" in app or "test" in app:
            app = "teste"
            domain = "financeiro"
            search_key = "teste-test"

            if "teste-test" in search_key and n <= 1:
                n = 2
                json_object = {
                    "search_key": search_key,
                    "application": app,
                    "domain": domain,
                    "shared": shared,
                    "env": env,
                    "account": account,
                }
                json_objects.append(json_object)
                continue
        else:
            json_object = {
                "search_key": search_key,
                "application": app,
                "domain": domain,
                "shared": shared,
                "env": env,
                "account": account
            }

            json_objects.append(json_object)

    with open(output_file, 'w', encoding='utf-8') as json_file:
        json.dump(json_objects, json_file, indent=4)

def process_csv_files_in_folder(folder_path, output_file, output_json_file):
    for filename in os.listdir(folder_path):
        if filename.endswith('.csv'):
            input_file = os.path.join(folder_path, filename)
            process_csv_file(input_file, output_file, output_json_file)


if __name__ == "__main__":
    '''
    input_foder = o script faz a leitura de todos os csv em uma pasta. Recebe um diretorio
    output_file = o nome do csv a ser escrito
    output_json_file = o nome do arquivo json a ser escrito
    account = o nome oficial da conta aws
    '''
    # read all csv in folder
    input_folder = './'
    output_file = input_folder + '/result.csv'
    output_json_file = input_folder + '/application-domain.json'
    account = 'MicroservicesRD'
    process_csv_files_in_folder(input_folder, output_file, output_json_file)

