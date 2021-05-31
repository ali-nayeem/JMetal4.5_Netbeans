import glob

write_file = open('Final_VAR.txt', 'w')
for f in glob.glob("VAR.*"):
    var_file = open(f, 'r')

    for line in var_file:
        write_file.write(line)

write_file.close()

