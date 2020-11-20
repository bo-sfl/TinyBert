with open("757053.txt", 'r') as f:
    lines = f.readlines()
with open("757054.txt", 'w') as f:
    for x in lines:
        f.write(x+'\n')