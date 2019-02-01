=begin
	KNN in ruby
    Erik Pires e Eduardo Roger
=end
require 'csv'

arrayDeEntrada = []
arrayDeSaida = []
entradaTreino = []
saidaTreino = []
entradaTeste = []
saidaTeste = []

def converteSaidaParaNumero (saida)
	if saida =='setosa'
		return 0
	elsif saida == 'versicolor'
		return 1
	else
		#Classe virginica
		return 2
	end
end

#Calcula distancia Euclidiana
def distanciaEuclidiana(vetor1, vetor2)
	distancia = 0
	
	vetor1.zip(vetor2).each do |v1, v2|
		componente = (v1 - v2)**2
		distancia += componente
	end

	return Math.sqrt(distancia)
end


def getNeighborsDistance(trainingSet, testInstance, k)
	distances = []
	for x in 0...trainingSet.length
		dist = distanciaEuclidiana(testInstance, trainingSet[x])
		distances << [dist, trainingSet[x], x]
	end
	distances = distances.sort
	neighbors = []
	for x in 0...k
		#Guarda o treino e a posicao dele no conjunto
		neighbors << [distances[x][1], distances[x][2]]
	end
	return neighbors

end

def getResponse(neighbors, saidaTreino)
	classeVotes = [[0,0],[0,1],[0,2]]
	for x in 0...neighbors.length
		posicao = neighbors[x][1]
		response = saidaTreino[posicao]
		for i in 0...classeVotes.length
		if response==classeVotes[i][1]
			classeVotes[i][0] +=1
		else
			classeVotes[i][0] = 1
		end
	end
	classificacao = classeVotes.sort 
	return classificacao[0][1]
end

#Calcula acuracia
def getAccuracy(saidaTeste, predictions)
	corretos = 0
	for x in 0...saidaTeste.length
		if saidaTeste[x]==predictions[x]
			corretos +=1
		end
	end
	return Float(corretos)/Float(saidaTeste.length)*100
end


#Ler os dados da base de dados que está no formado csv
customers = CSV.read('iris.csv')


#Converte valores que estao em string em float e classes em inteiros, jogando-os nos arrays de entrada e de saida
for x in customers
	arrayAuxiliar = []
	if x != customers[0]
		for elemento in x
			if(elemento!=x.last)
				valor = elemento.to_f
				arrayAuxiliar << valor
			else
				classe = converteSaidaParaNumero(elemento)
				arrayDeSaida << classe
			end
		end
		arrayDeEntrada << arrayAuxiliar
	end
end

a = Random.new()
for i in 0...arrayDeEntrada.length

	if a.rand < 0.60
		entradaTreino << arrayDeEntrada[i]
		saidaTreino << arrayDeSaida[i]
	else 
		entradaTeste << arrayDeEntrada[i]
		saidaTeste << arrayDeSaida[i]
	end
end
puts "Numero de elementos de treino: #{entradaTreino.length}"
puts "Numero de elementos de teste: #{entradaTeste.length}"

k = 3
#Faz a classificacao dos teste
predictions = []
entradaTeste.each do |teste|
	neighbors = getNeighborsDistance(entradaTreino, teste, k)

	classe = getResponse(neighbors, saidaTreino)
	predictions << classe
end

#Calcula a acurácia
acuracia = getAccuracy(saidaTeste,predictions)
puts "Acuracia #{acuracia}"
