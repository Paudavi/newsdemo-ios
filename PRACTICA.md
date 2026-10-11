# NewsDemo iOS: guía de práctica con XCUITest

La misma app que la de Android, en SwiftUI. **No tiene tests**: los escribís vos en el target `XCUIDemoUITests`.
Cada ejercicio dice *qué* probar y qué API buscar, pero no cómo resolverlo.

---

## 1. Cómo correr la app

1. Abrí `XCUIDemo.xcodeproj` y corré con **Cmd+R**.
2. Usuario demo: **pau@test.com / 123456**

> ⚠️ Tu `GreetingUITest` ahora va a fallar, porque la app arranca en el login.
> Para que vuelva a mostrar la pantalla del saludo, agregá antes del `launch()`:
> `app.launchArguments = ["-greetingDemo"]`

---

## 2. Mapa de pantallas e identifiers

En XCUITest buscás por **tipo + identifier**: `app.textFields["emailInput"]`, `app.buttons["loginButton"]`.

### Login (`LoginView`)
| identifier | Tipo en XCUITest | Comportamiento |
|---|---|---|
| `emailInput` | `textFields` | |
| `passwordInput` | `secureTextFields` (¡no es `textFields`!) | |
| `loginButton` | `buttons` | Deshabilitado hasta que los dos campos tengan texto |
| `errorText` | `staticTexts` | **No existe** hasta que hay un error; desaparece al editar |
| `demoHint` | `staticTexts` | |

Mensajes: "Ingresá tu email", "El email no es válido", "La contraseña debe tener al menos 6 caracteres", "Email o contraseña incorrectos".

### Feed (`FeedView`)
| identifier | Tipo | Comportamiento |
|---|---|---|
| `welcomeText` | `staticTexts` | "Hola, pau@test.com" |
| `settingsButton` | `buttons` | Abre Ajustes (label "Ajustes") |
| `searchInput` | `textFields` | Filtra por título |
| `categoryPicker` | `segmentedControls` | Segmentos: "Todas", "Tecnología", "Deportes", "Cultura" (se tocan como `buttons["Deportes"]`) |
| `loadingIndicator` | `activityIndicators` / `otherElements` | Visible mientras "carga la red" (**1,5 s**) |
| `articleList` | `collectionViews` (SwiftUI List) | 20 noticias |
| `articleRow_<id>` | `buttons` | Una fila; tocarla abre el detalle. Ej.: `articleRow_2` |
| `likedIcon_<id>` | `images` | El ♥ de la fila; existe solo si le diste me gusta |
| `swipeLike_<id>` | `buttons` | Aparece al **deslizar la fila hacia la izquierda** |
| `emptyState` | `staticTexts` | "No encontramos noticias" |

La lista también tiene **pull to refresh**: tirar hacia abajo recarga.

### Detalle (`ArticleDetailView`)
| identifier | Tipo | |
|---|---|---|
| `articleCategory`, `articleTitle`, `articleBody` | `staticTexts` | |
| `likeButton` | `buttons` | "Me gusta" ↔ "Te gusta ♥" (mirá su `.label`) |
| `shareButton` | `buttons` | Abre la hoja de Compartir **del sistema** |
| `notFoundText` | `staticTexts` | Si el id no existe |

Volver: el botón "atrás" de la barra de navegación (`app.navigationBars.buttons.firstMatch`).

**Deep link:** `newsdemo://article/5` abre el artículo 5 (ya está registrado en `XCUIDemo-Info.plist`). Probalo a mano con la app instalada:
```
xcrun simctl openurl booted "newsdemo://article/5"
```

### Ajustes (`SettingsView`)
| identifier | Tipo | Comportamiento |
|---|---|---|
| `notificationsToggle` | `switches` | La primera vez aparece el popup **del sistema** "¿Permitir notificaciones?" |
| `notificationsStatus` | `staticTexts` | "Notificaciones activadas/desactivadas", "Permiso... denegado", "Notificación programada" |
| `testNotificationButton` | `buttons` | Programa una notificación local a los **2 s**: "Tenés noticias nuevas" |
| `fontSizePicker` | `segmentedControls` | "Chica" / "Mediana" / "Grande" (se guarda en disco) |
| `fontSelectedLabel` | `staticTexts` | "Tamaño seleccionado: Mediana" |
| `logoutButton` | `buttons` | Abre una **alerta de la app** "¿Cerrar sesión?" con "Sí, salir" / "Cancelar" |

---

## 3. Ganchos para tests (ya están en la app)

Se mandan desde el test **antes** de `app.launch()`:

| Qué | Cómo | Para qué |
|---|---|---|
| `-uiTesting` | `app.launchArguments` | Borra preferencias guardadas (arranca como recién instalada) |
| `-loggedIn` | `app.launchArguments` | Entra directo al feed, sin pasar por el login |
| `-greetingDemo` | `app.launchArguments` | Muestra la pantalla de la lección 0 |
| `NETWORK_DELAY_MS` | `app.launchEnvironment["NETWORK_DELAY_MS"] = "0"` | Cambia la demora de la "red" |

**Datos fijos:** 20 noticias, 7 Tecnología, 7 Deportes, 6 Cultura.
"uruguay" da 5 resultados (2 de Deportes). "Mundial" da 1.
El artículo 2 es "Peñarol gana el clásico en el Centenario", el 5 es "La Celeste se prepara para el Mundial" y el 20, "Rugby: Los Teros confirman su plantel".

---

## 4. Ejercicios

✅ = hecho. Tip general: cada test empieza con `XCUIApplication()`, los launch arguments y `launch()`.

### Nivel 1: interacciones básicas (Login)
- [ ] **1.1** El botón está deshabilitado al abrir y se habilita con los dos campos llenos.
  *Buscá:* `.isEnabled`
- [ ] **1.2** Email inválido y contraseña corta muestran su error. Verificá el texto con `.label`.
- [ ] **1.3** El error desaparece al escribir.
  *Buscá:* `.exists`, `waitForNonExistence(timeout:)`
- [ ] **1.4** Login correcto muestra `welcomeText`.
- [ ] **1.5** ¿Qué pasa si escribís en `secureTextFields` buscándolo como `textFields`? Entendé el error.
- [ ] **1.6** Si `typeText` falla con *"Neither element nor any descendant has keyboard focus"*: Simulator → I/O → Keyboard → destildá "Connect Hardware Keyboard".

### Nivel 2: organizar el código
- [ ] **2.1** Creá **Screen Objects** (`LoginScreen`, `FeedScreen`...) con los elementos y las acciones de cada pantalla.
- [ ] **2.2** Creá una clase base `BaseUITestCase: XCTestCase` que arme la app con los launch arguments comunes.

### Nivel 3: datos asíncronos
- [ ] **3.1** Con `-loggedIn`, verificá que la fila 20 existe. Hacelo primero **sin** esperar y mirá qué pasa.
- [ ] **3.2** Arreglalo esperando bien.
  *Buscá:* `waitForExistence(timeout:)`, `XCTNSPredicateExpectation`
- [ ] **3.3** Verificá que `loadingIndicator` aparece y después desaparece.
- [ ] **3.4** Con `NETWORK_DELAY_MS=0`, ¿cambia algo? ¿Para qué sirve en CI?

### Nivel 4: listas y gestos
- [ ] **4.1** Scrolleá hasta la noticia 20 y abrila.
  *Buscá:* `swipeUp()`, `isHittable`, un loop con límite de intentos
- [ ] **4.2** Buscador: "uruguay" da 5 filas.
  *Buscá:* `app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'articleRow_'")).count`
- [ ] **4.3** "xyz123" muestra `emptyState`.
- [ ] **4.4** Segmento "Deportes" da 7. Deportes + "uruguay" da 2.
- [ ] **4.5** **Swipe:** deslizá la fila 2 a la izquierda, tocá "Me gusta" y verificá que aparece `likedIcon_2`.
  *Buscá:* `swipeLeft()`
- [ ] **4.6** **Pull to refresh:** tirá la lista hacia abajo.
  *Buscá:* `press(forDuration:thenDragTo:)` con coordenadas (`coordinate(withNormalizedOffset:)`)

### Nivel 5: navegación
- [ ] **5.1** Feed → Ajustes → volver.
- [ ] **5.2** Feed → detalle → me gusta → volver: el ♥ se ve en la fila.
- [ ] **5.3** **E2E completo:** login → noticia → me gusta → volver → ajustes → cerrar sesión → login.

### Nivel 6: deep links y hojas del sistema
- [ ] **6.1** Abrí `newsdemo://article/5` desde el test y verificá el título.
  *Buscá:* `app.open(URL)` (o abrir el link desde Safari: `XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")`)
- [ ] **6.2** `newsdemo://article/999` muestra `notFoundText`.
- [ ] **6.3** Tocá Compartir y verificá que se abrió la hoja del sistema. Cerrala.
  *Pista:* no es parte de tu app. Explorá con `print(app.debugDescription)`.

### Nivel 7: alertas (app vs. sistema)
- [ ] **7.1** Cerrar sesión → "Cancelar": la alerta se cierra y seguís en Ajustes.
  *Buscá:* `app.alerts["¿Cerrar sesión?"].buttons["Cancelar"]`
- [ ] **7.2** Cerrar sesión → "Sí, salir": volvés al login.
- [ ] **7.3** Prendé las notificaciones. Aparece el popup **del sistema**, que NO es de tu app. Tocá "Permitir".
  *Buscá (dos formas):* `addUIInterruptionMonitor`, o `XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts`
- [ ] **7.4** Lo mismo, pero tocando "No permitir". Verificá "Permiso de notificaciones denegado".
  *Pista:* el permiso queda guardado. Investigá `app.resetAuthorizationStatus(for: .notifications)` o borrar la app del simulador.
- [ ] **7.5** Elegí "Grande" en el picker y verificá el label.

### Nivel 8: ciclo de vida
- [ ] **8.1** Buscá "uruguay", mandá la app a segundo plano y traela de vuelta: siguen 5 filas.
  *Buscá:* `XCUIDevice.shared.press(.home)`, `app.activate()`
- [ ] **8.2** Elegí "Grande", **cerrá la app** (`app.terminate()`), volvé a abrirla **sin** `-uiTesting`, y verificá que se acordó.
- [ ] **8.3** Lo mismo **con** `-uiTesting`: vuelve a "Mediana". ¿Por qué importa esto para tener tests independientes?
- [ ] **8.4** Rotá el simulador (`XCUIDevice.shared.orientation = .landscapeLeft`) y verificá que el feed se sigue viendo.

### Nivel 9: notificaciones
- [ ] **9.1** Con el permiso dado, tocá "Enviar notificación de prueba", mandá la app a segundo plano y verificá que el banner "Tenés noticias nuevas" aparece en el **springboard**.

### Nivel 10: calidad de la suite
- [ ] **10.1** Unit tests de `LoginValidator` en el target `XCUIDemoTests` (`@testable import XCUIDemo`). Probá los valores límite.
- [ ] **10.2** Sacá una captura cuando un test falla y adjuntala al reporte.
  *Buscá:* `XCTAttachment`, `app.screenshot()`
- [ ] **10.3** Creá un **Test Plan** (`.xctestplan`) con dos configuraciones: "Smoke" (3 o 4 tests) y "Full". Lo va a usar el pipeline.

---

## 5. Comandos útiles

```bash
xcrun simctl list devices available     # simuladores instalados

xcodebuild test \
  -project XCUIDemo.xcodeproj \
  -scheme XCUIDemo \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:XCUIDemoUITests          # solo los UI tests

xcodebuild test ... -resultBundlePath build/results.xcresult   # guarda el reporte
open build/results.xcresult
```
