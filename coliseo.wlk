/*ARMAS*/

class ArmaDeFilo {
  const filo
  const longitud

  method filo() = filo.max(0).min(1)
  method poderDeAtaque() = filo * longitud
}

class  ArmaContundente {
  const peso

  method peso() = peso
  method poderDeAtaque() = peso
}

/*ARMADURA*/  

object casco {
  const puntosDeArmadura = 10

  method puntosDeArmadura() = puntosDeArmadura
}

object escudo {
  method puntosDeArmadura() = 5 + (Gladiador.destreza() * 0.1)
}

/*GLADIADORES*/

class Gladiador {
  var vida = self.unidadesDeVidaInicial()

  method fuerza()
  method destreza()
  method unidadesDeVidaInicial() = 100
  method vida() = vida
  method poderDeAtaque()
  method defensa()
  method puedeCombatir() = vida > 0
  method nombreDeGrupoCon(compañero)

  method atacar(unGladiador) {
    const danio = (self.poderDeAtaque() - unGladiador.defensa()).max(0)
    unGladiador.recibirDanio(danio)
  }
  method recibirDanio(unaCantidad) {
    vida = (vida - unaCantidad).max(0)
  }
  method pelear(unGladiador) {
    self.atacar(unGladiador)
    if(unGladiador.puedeCombatir()) unGladiador.atacar(self)
  }
  method armarGrupoCon(compañero) {
    return new Grupo(nombre = self.nombreDeGrupoCon(compañero), miembros = [self, compañero])
  }
  method curar() {
    vida = self.unidadesDeVidaInicial()
  }
}

class Mirmillon inherits Gladiador {
  var arma
  var armadura
  const fuerza

  override method fuerza() = fuerza
  override method destreza() = 15
  override method poderDeAtaque() = arma.poderDeAtaque() + fuerza
  override method defensa() = armadura.puntosDeArmadura() + self.destreza()
  override method nombreDeGrupoCon(compañero) = "mirmillolandia"

  method cambiarArmadura(nuevaArmadura) {
    armadura = nuevaArmadura
  }
  method cambiarArma(nuevaArma) {
    arma = nuevaArma
  }
}

class Dimachaerus inherits Gladiador {
  var destreza
  const armas = []

  override method fuerza() = 10
  override method destreza() = destreza
  override method poderDeAtaque() = self.fuerza() + armas.sum({arma => arma.poderDeAtaque()})
  override method defensa() = destreza / 2
  override method nombreDeGrupoCon(compañero){
    return "D-" + (self.poderDeAtaque() + compañero.poderDeAtaque())
  }
  override method atacar(unGladiador) {
    super(unGladiador)
    destreza += 1
  }

  method añadirArma(unArma){
    armas.add(unArma)
  }
  method quitarArma(unArma) {
    armas.remove(unArma)
  }
}


/*GRUPOS*/  

class Grupo {
  const nombre
  const miembros = []
  var peleas = 0

  method nombre() = nombre
  method cantDePeleas() = peleas
  method cantDeMiembros() = miembros.size()
  method contiene(unGladiador) = miembros.contains(unGladiador)

  method agregar(unGladiador) {
    miembros.add(unGladiador)
  }
  method quitar(unGladiador){
    miembros.remove(unGladiador)
  }
  method miembrosQuePuedenCombatir() = miembros.filter({miembro => miembro.puedeCombatir()})
  method puedeCombatir() = miembros.any({miembro => miembro.puedeCombatir()})
  method campeon() = self.miembrosQuePuedenCombatir().max({miembro => miembro.fuerza()})
  method registrarCombate() {
    peleas += 1
  }
  method curar() {
    miembros.forEach({miembro => miembro.curar()})
  }
}


/*COLISEO*/

object coliseo {
  const rounds = 3

  method organizarCombate(unContendiente, otroContendiente) {
    unContendiente.registrarCombate()
    otroContendiente.registrarCombate()
    rounds.times({n => self.disputarRound(unContendiente, otroContendiente)})
  }
  method disputarRound(unContendiente, otroContendiente) {
    if(unContendiente.puedeCombatir() && otroContendiente.puedeCombatir()){
      unContendiente.campeon().pelear(otroContendiente.campeon())
    }
  }
  method curar(unContendiente) {
    unContendiente.curar()
  }
}