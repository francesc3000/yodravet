import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  final String title = "APP MÓVILES. Términos y condiciones de uso\n";
  final String title2 = "TÉRMINOS Y CONDICIONES DE USO DE LA APLICACIÓN\n\n";
  final String intro =
      "Estos Términos y Condiciones regulan la descarga, acceso y utilización de la aplicación móvil YoDravet (en adelante, la «APLICACIÓN»), que Asociación ApoyoDravet pone a disposición de los usuarios. El usuario adquiere esta condición con la descarga y uso de la misma.Esta versión de la APLICACIÓN está disponible de forma gratuita en Google Play y Apple Store, el usuario reconoce y acepta cumplir con todos los términos y condiciones aplicables respecto a la obtención, descarga y actualización de la APLICACIÓN que estos stores respectivamente determinen.El acceso a la APLICACIÓN supone que el usuario reconoce haber aceptado y consentido sin reservas las presentes condiciones de uso.\n";
  final String paragraph1Title = "1. OBJETO\n";
  final String paragraph1 = "La APLICACIÓN tiene el objetivo de registrar la actividad física, cómo correr, caminar, montar en bicicleta sumando los kilómetros de todos los participantes en la Carrera. Algunos de los colectivos que pueden beneficiarse de este proyecto son corredores participantes. En el diseño y desarrollo de esta APLICACIÓN han intervenido profesionales especialistas, así como un grupo de usuarios que participaron en el período de prueba. La APLICACIÓN se pone a disposición de los usuarios para su uso personal (nunca empresarial). Funciona en un teléfono móvil con sistema operativo Android o IOS y con cámara frontal.\n";
  final String paragraph2Title = "2. FUNCIONALIDADES\n";
  final String paragraph2 = """Los usuarios que quieran utilizar la app deben registrarse para poder administrar sus datos personales, con excepción de los datos estadísticos (rankings) y datos
  informativos sobre la investigación al Dravet.
  Los usuarios que quieran utilizar la app deben registrarse para poder administrar sus datos personales, con excepción de los datos estadísticos (rankings) y datos informativos sobre la investigación al Dravet.
  Si los usuarios quieren colaborar subiendo sus kilómetros en apoyo a la investigación
  contra el Dravet, deben asociar su cuenta en la app con una cuenta en Strava. El
  registro en Strava se realiza a través de su Api de registro de terceros, no se guardan
  datos del usuario de Strava en la app.
  Cuando un usuario sube kilómetros a la app se guardan los siguientes datos:
  - Fecha
  - Distancia
  - Tipo de Actividad (Carrera, Caminata, Bicicleta)
  - ID de usuario (ID interno de la app)

  """;
  final String paragraph3Title = "3. DERECHOS DE PROPIEDAD INTELECTUAL E INDUSTRIAL\n";
  final String paragraph3 = """Los derechos de propiedad
  intelectual e industrial sobre la APLICACIÓN son titularidad de Asociación
  ApoyoDravet, correspondiéndole el ejercicio exclusivo de los derechos de explotación
  de los mismos en cualquier forma y, en especial, los derechos de reproducción,
  distribución, comunicación pública y transformación.Los terceros titulares de derechos
  de propiedad intelectual e industrial sobre fotografías, logotipos, y cualesquiera otros
  símbolos o contenidos incluidos en la APLICACIÓN han concedido las correspondientes
  autorizaciones para su reproducción, distribución y puesta a disposición del público.El
  usuario reconoce que la reproducción, modificación, distribución, comercialización,
  descompilación, desensamblado, utilización de técnicas de ingeniería inversa o de
  cualquier otro medio para obtener el código fuente, transformación o publicación de
  cualquier resultado de pruebas de referencias no autorizadas de cualquiera de los
  elementos y utilidades integradas dentro del desarrollo constituye una infracción de
  los derechos de propiedad intelectual de Asociación ApoyoDravet, obligándose, en
  consecuencia, a no realizar ninguna de las acciones mencionadas.
  
  """;
  final String paragraph4Title = "4. POLÍTICA DE PRIVACIDAD\n";
  final String paragraph4 = """"¿Quién es el responsable del tratamiento de sus datos personales?
  Asociación ApoyoDravet es el responsable del tratamiento de los datos personales del
  usuario y le informa de que estos datos serán tratados de conformidad con lo
  dispuesto en el Reglamento (UE) 2016/679, de 27 de abril (GDPR), y la Ley Orgánica
  3/2018, de 5 de diciembre (LOPDGDD), por lo que se le facilita la siguiente información
  del tratamiento:
  ¿Para qué tratamos sus datos personales?
  Tratamos sus datos personales para las finalidades descritas en el apartado «1.
  OBJETO» de estos términos y condiciones.
  ¿Por qué motivo podemos tratar sus datos personales?
  El tratamiento de sus datos está legitimado con base en:
  ser necesario para la relación contractual, de la que usted es parte, que supone la
  aceptación de estos términos y condiciones de uso (art. 6.1.b GDPR).su consentimiento
  otorgado para uno o varios fines específicos (artículo 6.1.a GDPR) al cumplimentar
  cualquiera de los formularios y/o formas de contacto que ponemos a su disposición en
  esta APLICACIÓN y marcar la casilla habilitada para tal efecto.nuestro interés legítimo
  en el caso de dar respuesta a sus encargos o solicitudes realizadas a través de
  cualquiera de los formularios y/o formas de contacto que ponemos a su disposición en
  la APLICACIÓN (artículo 6.1.f GDPR)
  ¿Durante cuánto tiempo guardaremos sus datos personales?
  Conservaremos sus datos personales durante no más tiempo del necesario para
  mantener el fin del tratamiento, es decir, mientras dure la relación contractual objeto
  del uso de la APLICACIÓN (incluyendo la obligación de conservarlos durante los plazos
  de prescripción aplicables), y cuando ya no sean necesarios para tal fin, se suprimirán
  con medidas de seguridad adecuadas para garantizar la anonimización o la destrucción
  total de los mismos.
  ¿A quién facilitamos sus datos personales?
  Sus datos personales se comunicarán a:
  Las Administraciones Públicas y otras entidades privadas para el cumplimiento de las
  obligaciones legales a las que Asociación ApoyoDravet está sujeto por sus
  actividades.Los proveedores que precisen acceder a los datos personales del usuario
  para la prestación de los servicios que Asociación ApoyoDravet les haya contratado, o
  que por el propio funcionamiento de los servicios electrónicos (aplicación, página web
  y correos electrónicos) puedan tener acceso a determinados datos personales. Con
  todos ellos Asociación ApoyoDravet tiene suscritos los contratos de confidencialidad y
  de encargo de tratamiento de datos personales necesarios y exigidos por la normativa
  para proteger su privacidad (artículo 28.3 GDPR).
  El registro y el control de sesiones de usuario se realiza mediante la plataforma
  ...........(en el caso de que exista una plataforma externa que se encarga del control de
  sesiones, por ejemplo: Firebase Authentication, de Google, y, si es el caso, detallar las
  condiciones de uso)...........
  La APLICACIÓN utilizará Google Analytics como herramienta para conocer el uso y las
  tendencias de interacción de la misma. Asociación ApoyoDravet podrá utilizar la
  información personal que nos facilite de forma disociada (sin identificación personal)
  para fines internos, tales como la elaboración de estadísticas.
  La APLICACIÓN podrá recabar, almacenar o acumular determinada información de
  carácter no personal referente a su uso. Google Analytics se rige por las condiciones
  generales de Google accesibles en http://www.google.com/analytics/terms/es.html y
  las políticas de privacidad de Google accesibles en
  https://www.google.es/intl/es/policies/privacy/.¿Cuáles son los derechos que le
  asisten como usuario?
  Derecho a retirar el consentimiento en cualquier momento.Derecho de acceso,
  rectificación, portabilidad y supresión de sus datos, y de limitación u oposición a su
  tratamiento.Derecho a presentar una reclamación ante la autoridad de control
  (www.aepd.es) si considera que el tratamiento no se ajusta a la normativa vigente.
  Datos de contacto para ejercer sus derechos:
  Asociación ApoyoDravet. Merkezabal, 34 1 d - 20009 San Sebastián(Guipúzcoa). E-mail:
  contacto@apoyodravet.eu
  Datos de contacto del delegado de protección de datos: CONSULTING NORMATIVO, SL,
  Fénix, 19, 28023 MADRID - administracion@fundacionprotecciondedatos.es
  
  """;

  final String paragraph5Title = "5. CARÁCTER OBLIGATORIO O FACULTATIVO DE LA INFORMACIÓN FACILITADA POR EL USUARIO\n";
  final String paragraph5 = """Los usuarios, mediante la marcación de las casillas correspondientes y entrada de
  datos en los campos, marcados con un asterisco (*) en los formularios de la
  APLICACIÓN, aceptan expresamente y de forma libre e inequívoca que sus datos
  personales son necesarios para atender su petición, por parte del prestador, siendo
  voluntaria la inclusión de datos en los campos restantes. El usuario garantiza que los
  datos personales facilitados a Asociación ApoyoDravet son veraces y se hace
  responsable de comunicar cualquier modificación de los mismos.
  Asociación ApoyoDravet informa de que todos los datos solicitados a través de la
  APLICACIÓN son obligatorios, ya que son necesarios para la prestación de un servicio
  óptimo al Usuario. En caso de que no se faciliten todos los datos, no se garantiza que la
  información y servicios facilitados sean completamente ajustados a sus necesidades.
  
  """;

  final String paragraph6Title = "6. MEDIDAS DE SEGURIDAD\n";
  final String paragraph6 = """De conformidad con lo dispuesto en las normativas vigentes en protección de datos
  personales, el RESPONSABLE está cumpliendo con todas las disposiciones de las
  normativas GDPR y LOPDGDD para el tratamiento de los datos personales de su
  responsabilidad, y manifiestamente con los principios descritos en el artículo 5 del
  GDPR, por los cuales son tratados de manera lícita, leal y transparente en relación con
  el interesado y adecuados, pertinentes y limitados a lo necesario en relación con los
  fines para los que son tratados.
  Asociación ApoyoDravet garantiza que ha implementado políticas técnicas y
  organizativas apropiadas para aplicar las medidas de seguridad que establecen el GDPR
  y la LOPDGDD con el fin de proteger los derechos y libertades de los usuarios y les ha
  comunicado la información adecuada para que puedan ejercerlos.
  Toda transferencia de información que la APLICACIÓN realiza con servidores en la
  nube (cloud), propios o de terceros, se realiza de manera cifrada y segura a través de
  un protocolo seguro de transferencia de hipertexto (HTTPS), que además garantiza que
  la información no pueda ser interceptada.
  Añadir cualquier información relativa a la seguridad, como puede ser, por ejemplo, la
  transferencia de información a servidores propios, disposición de API, conexiones
  cifradas, etc.
  Para más información sobre las garantías de su privacidad, puede dirigirse a Asociación
  ApoyoDravet.
  
  """;

  final String paragraph7Title = "7. EXCLUSIÓN DE RESPONSABILIDAD\n";
  final String paragraph7 = """Asociación ApoyoDravet se reserva el derecho de editar, actualizar, modificar,
      suspender, eliminar o finalizar los servicios ofrecidos por la APLICACIÓN, incluyendo
  todo o parte de su contenido, sin necesidad de previo aviso, así como de modificar la
  forma o tipo de acceso a esta.Las posibles causas de modificación pueden tener lugar
  por motivos tales como su adaptación a las posibles novedades legislativas y cambios
  en la propia APLICACIÓN, así como a las que se puedan derivar de los códigos tipos
  existentes en la materia o por motivos estratégicos o corporativos.Asociación
  ApoyoDravet no será responsable del uso de la APLICACIÓN por un menor de edad,
      siendo la descarga y uso de la APLICACIÓN exclusiva responsabilidad del usuario.La
  APLICACIÓN se presta «tal y como es» y sin ninguna clase de garantía. Asociación
  ApoyoDravet no se hace responsable de la calidad final de la APLICACIÓN, ni de que
  esta sirva y cumpla con todos los objetivos de la misma. No obstante lo anterior,
      Asociación ApoyoDravet se compromete en la medida de sus posibilidades a contribuir
  en la mejora de la calidad de la APLICACIÓN, pero no puede garantizar la precisión ni la
  actualidad del contenido de la misma.La responsabilidad de uso de la APLICACIÓN
  corresponde solo al usuario. Salvo lo establecido en estos Términos y Condiciones,
  Asociación ApoyoDravet no es responsable de ninguna pérdida o daño que se
  produzca en relación con la descarga o el uso de la APLICACIÓN, tales como los
  producidos a consecuencia de fallos, averías o bloqueos en el funcionamiento de la
  APLICACIÓN (por ejemplo, y sin carácter limitativo: error en las líneas de
  comunicaciones, defectos en el hardware o software de la APLICACIÓN o fallos en la
  red de Internet). Igualmente, Asociación ApoyoDravet tampoco será responsable de
  los daños producidos a consecuencia de un uso indebido o inadecuado de la
  APLICACIÓN por parte de los usuarios.8. LEGISLACIÓN Y FUEROEl usuario acepta que la
  legislación aplicable y los Juzgados y Tribunales competentes para conocer de las
  divergencias derivadas de la interpretación o aplicación de este clausulado son los
  españoles, y se somete, con renuncia expresa a cualquier otro fuero, a los juzgados y
  tribunales más cercanos a la ciudad de San Sebastián.He leído y acepto las condiciones
  de uso de la APLICACIÓN.
  
  """;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(10.0),
    color: Colors.white,
    child: ListView(
      children: [
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text: "",
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextSpan(
                  text: title2
              ),
              TextSpan(
                  text: intro
              ),
              TextSpan(
                  text: paragraph1Title
              ),
              TextSpan(
                  text: paragraph1
              ),
              TextSpan(
                  text: paragraph2Title
              ),
              TextSpan(
                  text: paragraph2
              ),
              TextSpan(
                  text: paragraph3Title
              ),
              TextSpan(
                  text: paragraph3
              ),
              TextSpan(
                  text: paragraph4Title
              ),
              TextSpan(
                  text: paragraph4
              ),
              TextSpan(
                  text: paragraph5Title
              ),
              TextSpan(
                  text: paragraph5
              ),
              TextSpan(
                  text: paragraph6Title
              ),
              TextSpan(
                  text: paragraph6
              ),
              TextSpan(
                  text: paragraph7Title
              ),
              TextSpan(
                  text: paragraph7
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
