module ApplicationHelper
  def rotulo_enum(modelo, atributo, valor)
    t("enums.#{modelo.model_name.i18n_key}.#{atributo}.#{valor}")
  end

  def opcoes_enum(modelo, atributo)
    modelo.public_send(atributo.to_s.pluralize).keys.map { |valor| [rotulo_enum(modelo, atributo, valor), valor] }
  end

  def badge(registro, atributo)
    valor = registro.public_send(atributo)
    tag.span(rotulo_enum(registro.class, atributo, valor), class: "badge badge-#{valor}")
  end

  def data(valor) = valor ? l(valor) : "–"

  def erro_campo(registro, atributo)
    mensagens = registro.errors.full_messages_for(atributo)
    tag.small(mensagens.to_sentence, class: "erro") if mensagens.any?
  end
end
