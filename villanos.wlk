import wollok.game.*
import elementosDelJuego.*

class Villano inherits Personaje {
  var pasoActual = 0
  var property camino
  var persiguiendo = false
  var property nivel = nivel1
  var estaAtacando = false
  var indiceAtaque = 0
  const mensajesAtaque
  var property estaTransformado = false
  var property animal = null

  override method image() {
    if (estaTransformado) {
      return animal + direccion.numero() + ".png"
    }
    const frame = if (estaAtacando) "A"
                  else if (usandoFrameA) "A"
                  else "B"
    return nombre + direccion.numero() + frame + ".png"
  }

  method veAl(heroe) {
    return direccion.enLineaDeVision(self, heroe)
  }

  method hayObstaculoEntreX(xMin, xMax, y) {
    if (xMax - xMin <= 1) return false
    return (xMin + 1 .. xMax - 1).any({ x => nivel.hayObstaculoEn(game.at(x, y)) })
  }

  method hayObstaculoEntreY(x, yMin, yMax) {
    if (yMax - yMin <= 1) return false
    return (yMin + 1 .. yMax - 1).any({ y => nivel.hayObstaculoEn(game.at(x, y)) })
  }

  method dirHaciaHeroe(heroe) {
    const dx = heroe.position().x() - self.position().x()
    const dy = heroe.position().y() - self.position().y()
    if (dx.abs() >= dy.abs()) {
      if (dx >= 0) return este
      else return oeste
    } else {
      if (dy > 0) return norte
      else return sur
    }
  }

  method moverse(heroe) {
    if (estaTransformado) {
      if (!camino.isEmpty()) {
        const dir = camino.get(pasoActual)
        self.moverseHacia(dir)
        pasoActual = (pasoActual + 1) % camino.size()
      }
    } else if (!estaAtacando) {
      if (!persiguiendo) {
        persiguiendo = self.veAl(heroe)
      }
      if (persiguiendo) {
        const dir = self.dirHaciaHeroe(heroe)
        self.moverseHacia(dir)
      } else if (!camino.isEmpty()) {
        const dir = camino.get(pasoActual)
        self.moverseHacia(dir)
        pasoActual = (pasoActual + 1) % camino.size()
      }
    }
  }

  method moverseHacia(nuevaDireccion) {
    const nuevaPos = nuevaDireccion.siguiente(position)
    if (!nivel.hayObstaculoEn(nuevaPos)) {
      self.actualizarAnimacion(nuevaDireccion)
      position = nuevaPos
    }
  }

  method estaAdjacenteA(heroe) {
    const dx = (self.position().x() - heroe.position().x()).abs()
    const dy = (self.position().y() - heroe.position().y()).abs()
    return (dx == 1 && dy == 0) || (dx == 0 && dy == 1)
  }

  method atacar(heroe) {
    if (!estaTransformado && !estaAtacando) {
      heroe.recibirDaño(10)
      estaAtacando = true
      game.say(self, mensajesAtaque.get(indiceAtaque))
      indiceAtaque = (indiceAtaque + 1) % mensajesAtaque.size()
      game.onTick(1000, "finAtaque" + nombre, {
        estaAtacando = false
        game.say(self, "")
        game.removeTickEvent("finAtaque" + nombre)
      })
    }
  }

  method puntosOtorgados() = nivel.puntosPorDerrotar(self)

  override method recibirImpacto(papa) {
    if (!estaTransformado) {
      estaTransformado = true
      animal = ["condor", "lagarto", "llama", "mula"].anyOne()
      papa.personaje().ganarPuntos(self.puntosOtorgados())
      if (estaAtacando) {
        estaAtacando = false
        game.say(self, "")
        game.removeTickEvent("finAtaque" + nombre)
      }
    }
    papa.destruir()
  }
}
