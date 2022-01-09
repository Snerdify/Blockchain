#block=(parent_hash,transcations,hash_itself)

def get_parent_hash(block):
    return block[0]


def get_transaction(block):
    return block[1]

def get_hash_itself(block):
    return block[2]


#create a block in the blockchain
def create_block(transactions,parent_hash):
    hash_itself=hash((transactions,parent_hash))
    return (parent_hash,transactions,hash_itself)  

#function to create a genesis block

def create_genesis_block(transactions):
    return create_block(transactions,0)


#create a genesis block

genesis_block=create_genesis_block("Alice paid $100 to Bob")

#print the hash of genesis block

genesis_block_hash=get_hash_itself(genesis_block)
print("genesis block hash :",genesis_block_hash)

#create another block
block1=create_block("Alice paid $90 to Clara",genesis_block_hash)


#print the hash of the new block
block1_hash=get_hash_itself(block1)
print("block1_hash:",block1_hash)
