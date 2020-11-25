import 'dart:math';

class Node {
  String attribute;
  List<Pair> children;
  String answer;
  Node(
    this.attribute, {
    this.children,
    this.answer,
  });
}

//log calculation.
double logBase(num x, num base) => log(x) / log(base);

//calculating the entropy of the target attribute of the main/sub table.
double entropy(List data) {
  final List attribute = data.toSet().toList();
  final List<double> counts = List.filled(attribute.length, 0);
  double sum = 0;

  if (attribute.isEmpty) {
    return 0;
  }
  for (var i = 0; i < attribute.length; i++) {
    for (final item in data) {
      if (attribute[i] == item) {
        counts[i]++;
      }
    }
    counts[i] = counts[i] / data.length;
  }
  for (final double item in counts) {
    sum += -1 * item * logBase(item, 2);
  }
  return sum;
}

List subtables(List<List<String>> data, int col, {bool delete = false}) {
  final Map map = {};
  final List colData = [];
  // data.forEach((e) => colData.add(e[col]));
  for (final e in data) {
    colData.add(e[col]);
  }
  final List attr = colData.toSet().toList();
  final List counts = List.filled(attr.length, 0);
  final int r = data.length, c = data[0].length;
  for (int x = 0; x < attr.length; x++) {
    for (int y = 0; y < r; y++) {
      if (data[y][col] == attr[x]) {
        counts[x]++;
      }
    }
  }
  for (int x = 0; x < attr.length; x++) {
    counts[x].forEach((e) {
      map[attr[x]] = List.filled(c, 0);
    });
    int pos = 0;
    for (int y = 0; y < r; y++) {
      if (data[y][col] == attr[x]) {
        if (delete) {
          data.elementAt(y).removeAt(col);
        }
        map[attr[x]][pos] = data[y];
        pos++;
      }
    }
  }
  return [attr, map];
}

List lastColumn(List data) {
  final List lastCols = [];
  for (final i in data) {
    lastCols.add(i.last);
  }
  return lastCols;
}

double computeGain(List<List<String>> data, int col) {
  final List list = subtables(data, col);
  final List attr = list[0] as List;
  final Map map = list[1] as Map;
  final int totalSize = data.length;
  final List<double> entropies = List.filled(attr.length, 0.0);
  final List<double> ratio = List.filled(attr.length, 0.0);
  List lastCols = lastColumn(data);
  double totalEntropy = entropy(lastCols);
  for (int x; x < attr.length; x++) {
    ratio[x] = (map[attr[x]].length as int) / (totalSize * 1.0);
    lastCols.clear();
    lastCols = lastColumn(map[attr[x]] as List);
    entropies[x] = entropy(lastCols);
    totalEntropy = totalEntropy - ratio[x] * entropies[x];
  }

  return totalEntropy;
}

void printTree(Node node, int level) {
  if (node.answer.isNotEmpty) {
    final List<String> l = List.filled(level, "  ");
    print(l.join() + node.answer);
    return;
  }
  List<String> l = List.filled(level, "  ");
  print(l.join() + node.attribute);
  l.clear();
  for (final Pair val in node.children) {
    l = List.filled(level + 1, "  ");
    print(l.join() + val.val);
    printTree(val.node, level + 2);
  }
}

Node buildTree(List<List<String>> data, List<String> features) {
  final List lastCol = lastColumn(data);
  if (lastCol.toSet().length == 1) {
    final Node node = Node('');
    node.answer = lastCol.first as String;
    return node;
  }
  final int n = data.first.length - 1;
  final List<double> gains = List.filled(n, 0.0);
  for (var i = 0; i < n; i++) {
    gains[i] = computeGain(data, i);
  }
  final double splitValue = gains.fold(0, max);
  final splitIndex = gains.indexOf(splitValue);
  final Node node = Node(features[splitIndex]);
  final List<String> fea = List.of(
    features.getRange(0, splitIndex - 1),
  )..addAll(
      features.getRange(splitIndex + 1, features.length),
    );
  final List list = subtables(data, splitIndex, delete: true);
  final List attr = list[0] as List;
  final Map map = list[1] as Map;
  for (var i = 0; i < attr.length; i++) {
    final Node child = buildTree(map[attr[i]] as List<List<String>>, fea);
    node.children.add(Pair(attr[i] as String, child));
  }
  return node;
}

void classify(
  Node node,
) {}

/*
def subtables(data,col,delete):
    dic={}
    coldata=[row[col] for row in data] #one by one column values are stored in coldata
    attr=list(set(coldata)) #duplicate values are removed and only unique values are stored in attr 
    counts=[0]*len(attr) #all unique values are set to 0. If values are overcast,rainy,sunny counts will be [0,0,0]
    r=len(data) #length is 14 for original table and length is 5 for 2 subtables
    c=len(data[0])  # length is 5 for original table and 4 for the two subtables
    
    for x in range(len(attr)): 
        for y in range(r):
            if data[y][col]==attr[x]:   #counting how many sunny, rainy, overcast  
                counts[x]+=1 
    for x in range(len(attr)):
        dic[attr[x]]=[[0 for i in range(c)] for j in range(counts[x])]
        pos=0
        for y in range(r): 
            if data[y][col]==attr[x]:                   #deleting outlook column for subtable 2
                if delete:
                    del data[y][col]
                dic[attr[x]][pos]=data[y]
                pos+=1
    return attr,dic
    


def compute_gain(data,col):
    attr,dic = subtables(data,col,delete=False)    
    total_size=len(data)  #14
    entropies=[0]*len(attr) 
    ratio=[0]*len(attr)    
    total_entropy=entropy([row[-1] for row in data])   #Entropy(S) 
    for x in range(len(attr)): #0,1,2
        ratio[x]=len(dic[attr[x]])/(total_size*1.0)    #number of attribute values/total instances
        entropies[x]=entropy([row[-1] for row in dic[attr[x]]])   #calculate entropy of individual values (entropy(sv))
        total_entropy=total_entropy-ratio[x]*entropies[x]
    return total_entropy

def build_tree(data,features):
    lastcol=[row[-1] for row in data] 
    if(len(set(lastcol)))==1: #leaf node
        node=Node("")   #passing an empty string since there are no further children
        node.answer=lastcol[0]  #leaf node values
        return node   
    n=len(data[0])-1   #number of attributes = 5-1=4
    gains=[0]*n
    for col in range(n):
        gains[col]=compute_gain(data,col)    #compute gain for evry attribute
    split=gains.index(max(gains))   # Position of maximum gain is stored in split
    node=Node(features[split])   #creating a node with 3 members
    
    fea = features[:split]+features[split+1:]
    attr,dic=subtables(data,split,delete=True)

    for x in range(len(attr)):
        child=build_tree(dic[attr[x]],fea)    #build tree for each child attribute
        node.children.append((attr[x],child))
    return node


            
            
dataset,features=load_csv(r"D:\7sem\mllab\trainingdatasetlab3.csv")
node1=build_tree(dataset,features)
print("The decision tree for the dataset using ID3 algorithm is")
print_tree(node1,0)

def entropy(S):
    attr=list(set(S))
    if len(attr)==1:  
        return 0    #entropy is 0 when there are only positive or only negative instances
    counts=[0,0] 
    for i in range(2):  #0,1
        counts[i]=sum([1 for x in S if attr[i]==x])/(len(S)*1.0)  #counting the number of no instances and yes instances  
    sums=0
    for cnt in counts:
        sums+=-1*cnt*math.log(cnt,2)
    return sums



class Node:
    def _init_(self,attribute):   
        self.attribute=attribute
        self.children=[]
        self.answer=""  
      
    
*/
class Pair {
  final String val;
  final Node node;

  Pair(this.val, this.node);
}
