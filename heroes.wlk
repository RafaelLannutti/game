import wollok.game.*
import elementosDelJuego.*

class Heroe inherits Personaje(nombre = "Tupac", position = game.at(0, 2)) {
  var energia = 100
  var vidas = 3
  var posicionAnterior = game.at(0, 0)
  var nivelActual = nivel1
  var property tieneLlave = false
  var papasLanzadas = 0
  method nivelActual() = nivelActual
  method nivelActual(nuevoNivel) {
    nivelActual = nuevoNivel
  }
  var property cantPapasMax = 1
  const property papasActivas = []
  method energia() = energia
  method vidas() = vidas
  method perderVida() {
    vidas -= 1
    energia = 100
  }
  method recibirDaño(cantidad) {
    energia = (energia - cantidad).max(0)
    if (energia == 0) self.perderVida()
  }
  method moverseHacia(dir) {
    self.actualizarAnimacion(dir)
    const nuevaPosicion = dir.siguiente(position)
    if (self.esPosicionValida(nuevaPosicion)) {
      self.position(nuevaPosicion)
    }
  }
  method esPosicionValida(pos) = (pos.x().between(
    0,
    game.width() - 1
  ) && pos.y().between(
    nivelActual.yMinimo(),
    nivelActual.yMaximoPara(pos.x())
  )) && (!nivelActual.hayObstaculoEn(pos))
  method lanzarPapa() {
    if (papasActivas.size() < cantPapasMax) {
      papasLanzadas += 1
      const papa = new Papa(
        position = position,
        direccion = direccion,
        nivel = nivelActual,
        id = papasLanzadas,
        personaje = self
      )
      papasActivas.add(papa)
      papa.lanzar()
    }
  }
  method removerPapaActiva(papa) {
    papasActivas.remove(papa)
  }
}