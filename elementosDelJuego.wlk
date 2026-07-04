import wollok.game.*
import obstaculos.*
import villanos.*

object norte {
  method siguiente(position) = position.up(1)
  method numero() = 2
  method enLineaDeVision(villano, heroe) {
    const vx = villano.position().x()
    const vy = villano.position().y()
    const hx = heroe.position().x()
    const hy = heroe.position().y()
    
    return (hx == vx && hy > vy && !villano.hayObstaculoEntreY(vx, vy, hy))
  }
  
}

object sur {
  method siguiente(position) = position.down(1)
  method numero() = 1
  method enLineaDeVision(villano, heroe) {
    const vx = villano.position().x()
    const vy = villano.position().y()
    const hx = heroe.position().x()
    const hy = heroe.position().y()
    
    return (hx == vx && hy < vy && !villano.hayObstaculoEntreY(vx, hy, vy))
  }
}

object este {
  method siguiente(position) = position.right(1)
  method numero() = 3
  method enLineaDeVision(villano, heroe) {
    const vx = villano.position().x()
    const vy = villano.position().y()
    const hx = heroe.position().x()
    const hy = heroe.position().y()
    
    return (hx == vx && hy > vy && !villano.hayObstaculoEntreY(vx, vy, hy))
  }
}

object oeste {
  method siguiente(position) = position.left(1)
  method numero() = 4
  method enLineaDeVision(villano, heroe) {
    const vx = villano.position().x()
    const vy = villano.position().y()
    const hx = heroe.position().x()
    const hy = heroe.position().y()
    
    return (hx == vx && hy > vy && !villano.hayObstaculoEntreY(vx, vy, hy))
  }
}

class Personaje {
  var property position = game.at(0, 0)
  var property direccion = sur
  var usandoFrameA = true
  var property nombre = ""

  method image() {
    const frame = if (usandoFrameA) "A" else "B"
    return nombre + direccion.numero() + frame + ".png"
  }

  method actualizarAnimacion(nuevaDireccion) {
    if (direccion == nuevaDireccion) {
      usandoFrameA = !usandoFrameA
    } else {
      direccion = nuevaDireccion
      usandoFrameA = true
    }
  }

  method recibirImpacto(papa) {}
}

class Nivel {
  var property imagenHUD
  var property imagenFondo
  var property yMinimo = 1
  const property obstaculosDelNivel = []

  method obstaculos() = obstaculosDelNivel

  method hayObstaculoEn(pos) =
    obstaculosDelNivel.any({ obs => obs.ocupaCelda(pos) })

  method yMaximoPara(x)

  method puntosPorDerrotar(villano)
}

object nivel1 inherits Nivel(
  imagenHUD = "nivel1.png",
  imagenFondo = "fondo3.png",
  yMinimo = 3,
  obstaculosDelNivel = [
    new Obstaculo(position = game.at(3, 4), imagen = "Camion1.png", anchoCeldas = 3, altoCeldas = 3),
    new Obstaculo(position = game.at(9, 7), imagen = "Camion2.png", anchoCeldas = 3, altoCeldas = 3)
  ]
) {
  method caminoDemoledor() = [este, este, este, este, norte, norte, norte, norte, oeste, oeste, oeste, oeste, sur, sur, sur, sur]

  override method yMaximoPara(x) {
    if (x==0 or x==14) return 10
    if (x.between(1,2))  return 8
    if (x.between(3,6)) return 10
    if (x==7)  return 8
    if (x.between(8,11)) return 10
    if (x.between(12,13))  return 8
    return 8
  }

  override method puntosPorDerrotar(villano) {
    if (villano.nombre() == "demoledor") return 10
    return 5
  }
}

object nivel2 inherits Nivel(
  imagenHUD = "nivel2.png",
  imagenFondo = "fondo2.png",
  yMinimo = 3,
  obstaculosDelNivel = [
    new Obstaculo(position = game.at(2, 4), imagen = "Camion1.png", anchoCeldas = 3, altoCeldas = 3),
    new Obstaculo(position = game.at(6, 7), imagen = "Camion1.png", anchoCeldas = 3, altoCeldas = 3),
    new Obstaculo(position = game.at(11, 4), imagen = "Camion1.png", anchoCeldas = 3, altoCeldas = 3)
  ]
) {
  override method yMaximoPara(x) {
    if (x.between(1, 2) or x.between(12, 13)) return 9
    return 10
  }

  override method puntosPorDerrotar(villano) {
    if (villano.nombre() == "demoledor") return 15
    return 10
  }
}
class Cofre {
  var property position
  var property estaAbierto = false

  method image() {
    if (estaAbierto){ return "cofre.png"
    } else{ return "cofreC.png"
  }}

  method abrir() {
    estaAbierto = true
  }

  method recibirImpacto(papa) {}
}

class Llave {
  var property position
  method image() = "llave.png"
  method recibirImpacto(papa) {}
}

class PosteConCaja {
  var property position
  method image() = "poste.png"
  method recibirImpacto(papa) {}
}

class CorazonHUD {
  var property position
  var property indice
  var property personaje

  method image() {
    if (personaje.vidas() >= indice) {
      return "corazon.png"
    } else {
      return "vacio.png"
    }
  }

  method recibirImpacto(papa) {}
}

class BarraEnergiaHUD {
  var property position
  var property personaje

  method image() {
    const eng = personaje.energia()
    if (eng > 80) return "energia100.png"
    if (eng > 60) return "energia80.png"
    if (eng > 40) return "energia60.png"
    if (eng > 20) return "energia40.png"
    if (eng > 0)  return "energia20.png"
    return "energia0.png"
  }

  method recibirImpacto(papa) {}
}

class NivelHUD {
  var property position
  var property personaje

  method image() = personaje.nivelActual().imagenHUD()

  method recibirImpacto(papa) {}
}

class DigitoPuntajeHUD {
  var property position
  var property indice
  var property personaje

  method image() {
    const digito = self.obtenerDigito()
    return "n" + digito + ".png"
  }

  method obtenerDigito() {
    const pts = personaje.puntos()
    const divisor = if (indice == 0) 100
                    else if (indice == 1) 10
                    else 1
    return ((pts / divisor).truncate(0) % 10).toString()
  }

  method recibirImpacto(papa) {}
}

class Papa {
  var property position
  var property direccion
  var property nivel
  var property id
  var property personaje
  var estaActiva = true

  method image() = "papa" + direccion.numero() + ".png"

  method lanzar() {
    game.addVisual(self)
    game.onTick(200, "movPapa" + id, {
      self.avanzar()
    })
  }

  method avanzar() {
    const nuevaPos = direccion.siguiente(position)
    if (self.fueraDelTablero(nuevaPos) || nivel.hayObstaculoEn(nuevaPos) || (direccion == norte && nuevaPos.y() > 12)) {
      self.destruir()
    } else {
      position = nuevaPos
      self.verificarImpacto()
    }
  }

  method verificarImpacto() {
    game.colliders(self).forEach({ obj => obj.recibirImpacto(self) })
  }

  method fueraDelTablero(pos) =
    !pos.x().between(0, game.width() - 1) ||
    !pos.y().between(0, game.height() - 1)

  method destruir() {
    if (estaActiva) {
      estaActiva = false
      game.removeTickEvent("movPapa" + id)
      game.removeVisual(self)
      personaje.removerPapaActiva(self)
    }
  }

  method recibirImpacto(papa) {}
}

object menuInicio {
  method image() = "menuInicio.png" 
  method position() = game.at(0, 0)
}

object gestorDeNiveles {
  var property cofreActual = null
  var property posteActual = null
  var property villanoActual = null
  var property llaveActual = null
  const objetosNivel = []
  var tickMovimientoActivo = false 
  var property estaEnMenu = true
  var property estaJugando = false

  method mostrarMenu() {
    estaEnMenu = true
    estaJugando = false
    game.boardGround(nivel1.imagenFondo())
    if (!game.hasVisual(menuInicio)){game.addVisual(menuInicio)}
  }

  method configurarNivel1(heroe) {
    estaEnMenu = false
    estaJugando = true
    if (game.hasVisual(menuInicio)) {
      game.removeVisual(menuInicio)
    }
    game.boardGround(nivel1.imagenFondo())
    self.limpiarNivel()
    posteActual = new PosteConCaja(position = game.at(14, 10))
    cofreActual = new Cofre(position = game.at(0, 10))
    
    heroe.nivelActual(nivel1)
    heroe.position(game.at(0, 4))
    heroe.tieneLlave(false)
    if (!game.hasVisual(heroe)) game.addVisual(heroe)

    nivel1.obstaculos().forEach({ obs => 
      game.addVisual(obs)
      objetosNivel.add(obs)
    })

    game.addVisual(posteActual)
    objetosNivel.add(posteActual)
    
    game.addVisual(cofreActual)
    objetosNivel.add(cofreActual)

    llaveActual = new Llave(position = game.at(12, 14))

    villanoActual = new Villano(
      position = game.at(7, 5),
      nombre = "envenenador",
      direccion = este,
      camino = [norte,sur,este,oeste],
      mensajesAtaque = ["TOMA ESTO!"]
    )
    game.addVisual(villanoActual)
    objetosNivel.add(villanoActual)

    self.iniciarMovimientoVillano(heroe)
  }

  method pasarANivel2(heroe) {
    self.limpiarNivel()
    estaEnMenu = false
    estaJugando = true
    heroe.nivelActual(nivel2)
    game.boardGround(nivel2.imagenFondo())
    heroe.position(game.at(0, 4)) 
    heroe.tieneLlave(false)
    posteActual = new PosteConCaja(position = game.at(14, 10))
    cofreActual = new Cofre(position = game.at(0, 10)) 
    llaveActual = new Llave(position = game.at(12, 14)) 
    villanoActual = new Villano(
      position = game.at(7, 5), 
      nombre = "demoledor",
      direccion = este,
      camino = [norte,sur,este,oeste],
      mensajesAtaque = ["TOMA ESTO!"]
    )
    
    nivel2.obstaculos().forEach({ obs => 
      game.addVisual(obs)
      objetosNivel.add(obs)
    })

    game.addVisual(posteActual)
    objetosNivel.add(posteActual)
    
    game.addVisual(cofreActual)
    objetosNivel.add(cofreActual)

    game.addVisual(villanoActual)
    objetosNivel.add(villanoActual)
    
    self.iniciarMovimientoVillano(heroe)
  }

  method limpiarNivel() {
    objetosNivel.forEach({ obj => 
      if (game.hasVisual(obj)) game.removeVisual(obj) 
    })
    objetosNivel.clear()
    if (llaveActual != null && game.hasVisual(llaveActual)) {
      game.removeVisual(llaveActual)
    }
    self.detenerMovimientoVillano()
  }

  method iniciarMovimientoVillano(heroe) {
    if (!tickMovimientoActivo) {
      game.onTick(500, "movimientoVillano", {
        if (game.hasVisual(villanoActual)) {
          villanoActual.moverse(heroe)
          if (villanoActual.estaAdjacenteA(heroe)) {
            villanoActual.atacar(heroe)
          }
        }
      })
      tickMovimientoActivo = true
    }
  }

  method detenerMovimientoVillano() {
    if (tickMovimientoActivo) {
      game.removeTickEvent("movimientoVillano")
      tickMovimientoActivo = false
    }
  }

  method obtenerObjetosQueCaen(heroe) {
    const objetos = []
    heroe.nivelActual().obstaculos().forEach({ obs => objetos.add(obs) })
    if (!villanoActual.estaTransformado()) {
      objetos.add(villanoActual)
    }
    return objetos
  }
}
