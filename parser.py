
import csv
import sys
import traceback
import io

class Row:

	def __init__(self, title, author, abstract, publisher, date_issued, doi, issn, language, tipe, volume, issue, page):
		self.title = title
		self.author = author
		self.abstract = abstract
		self.publisher = publisher
		self.date_issued = date_issued
		self.doi = doi
		self.issn = issn
		self.language = language
		self.tipe = tipe
		self.volume = volume
		self.issue = issue
		self.page = page
	
	def __str__(self):
		info = ""
		try:
			#info += "\nROW #" + str(Row.row_count)
			info += "dc.title[en_US] = " + str(self.title)
			info += "\ndc.contributor.author[en_US] = " + str(self.author)
			info += "\ndc.description.abstract[en_US] = " + str(self.abstract)
			info += "\ndc.publisher = " + str(self.publisher)
			info += "\ndc.date.issued = " + str(self.date_issued)
			info += "\ndc.identifier.doi = " + str(self.doi)
			info += "\ndc.identifier.issn = " + str(self.issn)
			info += "\ndc.language = " + str(self.language)
			info += "\ndc.type = " + str(self.tipe)
			info += "\ndc.publisher.volume = " + str(self.volume)
			info += "\ndc.publisher.issue = " + str(self.issue)
			info += "\ndc.publisher.page = " + str(self.page)
		except Exception:
			 print(traceback.format_exc())
		return info


def main():
	#global row_count

	counter = 0
	if len(sys.argv) != 3:
		print("Cara pakai: python parser.py <nama file txt> <nama file csv>")
		print("Contoh: python parser.py input.txt output.csv, atau bila terjadi kegagalan:")
		print("        python3 parser.py <nama file txt> <nama file csv>")
		sys.exit(0)

	input_file_name = sys.argv[1]
	output_file_name = sys.argv[2]
	codes = ["     ", "TI  -", "FAU -", "TA  -", "DP  -", "AID -", "LID -", "IS  -", "LA  -", "PT  -", "SO  -", "AB  -", "PG  -"]
	#output_file = open(output_file_name, "w")
	rows = []
	with io.open(input_file_name, encoding="utf8") as file:
		raw_data = file.read()
		raw_data = raw_data.replace('\n      ', '')
		raw_data = raw_data.splitlines()
		
		end_row = False

		title = None
		author = []
		abstract = None
		publisher = None
		date_issued = None
		doi = None
		issn = []
		language = None
		tipe = []
		volume = None
		issue = None
		page = None


		cleaned_data = []

		for d in raw_data:
			if d[0:5] in codes:
				cleaned_data.append(d)
			

		#print("CLEANED DATA")
		#for cd in cleaned_data:
		#	print(cd)

		for cd in cleaned_data:
			if not end_row:
				value = cd.split(" - ")[1]
				#print("VALUE:")
				#print(value)
				if cd[0:2] == "PG":
					page = "'" + value + "'"
					#page = value + " "
				if cd[0:2] == "IS":
					issn.append(value)
					#print("ISSN:", issn)
				if cd[0:2] == "DP":
					date_issued = value
				if cd[0:2] == "TI":
					title = value
				if cd[0:2] == "TA":
					publisher = value
				if cd[0:3] == "LID":
					doi = value.split("[doi]")[0] # ga yakin
				if cd[0:3] == "AID":
					if not doi:
						doi = value.split("[doi]")[0]
				if cd[0:2] == "AB":
					abstract = value
				if cd[0:3] == "FAU":
					author.append(value)
					#print("AUTHOR: ", author)
				if cd[0:2] == "LA":
					language = value
				if cd[0:2] == "PT":
					tipe.append(value)
				if cd[0:2] == "SO":
					end_row = True
					if not doi:
						try:
							value = value.replace(" Epub", "")
							doi = value.split("doi: ")[1]
							#print("[try] doi = " + doi)
							#doi =
						except IndexError:
							doi = ""
					try:
						#volume_issue_page = value.split(";")[1].split(" ")
						splitted = value.split(";")[1].split(" ")[0].split(":")
						if not page:
							page = splitted[1][:-1]
						volume = splitted[0].split("(")[0]
						issue = splitted[0].split("(")[1][:-1]
					except Exception:
						volume = issue = "[Format berbeda] " + value
						#print("GAGAAAAAAAALLL")
						#sys.exit(0)
					#(self, title, author, abstract, publisher, date_issued, doi, issn, language, tipe, volume, issue, page):
					#new_row = Row(title, author, abstract, publisher, date_issued, doi, issn, language, tipe, None, None, None)
					new_row = Row(title, author, abstract, publisher, date_issued, doi, issn, language, tipe, volume, issue, page)
					rows.append(new_row)
					end_row = False
					title = None
					author = []
					abstract = None
					publisher = None
					date_issued = None
					doi = None
					issn = []
					language = None
					tipe = []
					volume = None
					issue = None
					page = None
					#Row.row_count += 1
					counter += 1


	#print("FOR ROW IN ROWS")
	for i in range(len(rows)):
		print("\n\nROW #" + str(i+1))
		print(rows[i])


	with io.open(output_file_name, mode='w', newline='', encoding="utf8") as output:
		#writer = csv.writer(output, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
		writer = csv.writer(output)
		writer.writerow([
			"id",
			"collection",
			"dc.title[en_US]",
			"dc.contributor.author[en_US]",
			"dc.description.abstract[en_US]",
			"dc.publisher",
			"dc.date.issued",
			"dc.identifier.doi",
			"dc.identifier.issn",
			"dc.subject",
			"dc.language",
			"dc.type",
			"dc.publisher.volume",
			"dc.publisher.issue",
			"dc.publisher.page",
			"dc.identifier.uri"
		])
		for row in rows:
			authors = '||'.join(row.author)
			authors = '"' + authors + '"'
			types = "||".join(row.tipe)
			#types = '"' + types + '"'
			writer.writerow([
				"[Manual]", # id
				"[Manual]", # collection
				row.title,
				authors,
				row.abstract,
				row.publisher,
				row.date_issued,
				row.doi,
				row.issn[0], # ga yakin
				"[Manual]", # subject
				row.language,
				types, #row.tipe,
				row.volume, # volume
				row.issue, # issue
				row.page, # page
				"[Manual]", # uri
			])
	print("\n\n============================\nberhasil ngekonversi {} row. Hasil konversi dapat dilihat di {}".format(counter, output_file_name))

if __name__ == "__main__":
	try:
		main()
	except:
		print("ERROR. Mungkin .csvnya belum ditutup")
