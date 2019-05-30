import sys

if __name__ == '__main__':
    
    sicfilename = sys.argv[1]
    number = sys.argv[2]
    
    grammar_template = {
        '300': ('Noun', 'Noun', 'and', 'Noun'),
        '120': ('Adjective', 'and', 'Adjective', 'Noun'),
        '210': ('Adjective', 'Noun', 'and', 'Noun'),
        '201': ('Noun', 'Adverb', 'Noun') }

    part_of_speech = { 'Noun': 100, 'Adjective': 10 }

    # a small dictionary is used here for prototyping    
    dictionary = { 'PREPARATIONS' : 'Noun',
				'PHARMACEUTICAL' : 'Adjective',
				'BIOLOGICAL' : 'Adjective',
				'SURGICAL' : 'Adjective',
				'INSTRUMENTS' : 'Noun',
				'APPARATUS' : 'Noun',
				'SERVICES' : 'Noun',
				'SOFTWARE' : 'Noun',
				'SERVICES-PREPACKAGED' : 'Adjective',
				'STORES' : 'Noun',
				'PRODUCTS' : 'Noun',
				'OTHER' : 'Adjective',
				'DEVICES' : 'Noun',
				'RELATED' : 'Adverb',
				'SEMICONDUCTORS' : 'Noun',
				'EQUIPMENT' : 'Noun',
				'MACHINERY' : 'Noun',
				'PRODUCTS' : 'Noun',
				'COMMERCIAL' : 'Noun',
				'BANKS' : 'Noun',
				'STATE' : 'Noun',
				'INSURANCE' : 'Noun',
				'INVESTMENT' : 'Noun',
				'REAL' : 'Adjective',
				'GAS' : 'Noun',
				'NATURAL' : 'Adjective',
				'PETROLEUM' : 'Noun',
				'ESTATE' : 'Noun',
				'TRUSTS' : 'Noun',
				'INVESTMENT' : 'Noun'} 
    
    sicnames = {}
    
    with open(sicfilename, 'r') as sicfile:
        for line in sicfile:
            sic, _, name = line.strip().split(maxsplit=2)
            sicnames[int(sic)] = name
            
    for index in range(1, 11):
        tokencount = {}
        with open('Sector{index}-sic-freq.txt'.format(index=index), mode='r') \
                as sectorfile:
            sectorfile.readline()  # Skip first line
            for line in sectorfile:
                sic, freq, _ = line.strip().split(maxsplit=2)
                
                sicname = sicnames[int(sic)]
                
                for token in sicname.split():
                    if token == '&':
                        pass
                    else:
                        tokencount[token] = tokencount.get(token, 0) + int(freq)
        
        tokenlist = list((count, token) for token, count in tokencount.items())
        tokenlist.sort(reverse=True)
        del tokenlist[int(number):]
        
        grammarrule = grammar_template[str(
            sum(part_of_speech.get(dictionary[word], 1)
            for _, word in tokenlist))]
        
        output = []
        used = list(False for _ in tokenlist)
        for partofspeech in grammarrule:
            if partofspeech == 'and':
                output.append(partofspeech)
            else:
                for tokenindex, token in enumerate(tokenlist):
                    if dictionary[token[1]] == partofspeech and not used[tokenindex]:
                        output.append(token[1].title())
                        used[tokenindex] = True
                        break
        print ('{index},"{tokens}"'.format(index=index,
                                            tokens=' '.join(output)))
