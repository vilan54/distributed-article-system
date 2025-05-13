defmodule ArticleManagement.ModerationQueue do
  use GenServer

  @moduledoc """
  GenServer que maneja la cola de artículos pendientes de moderación.
  """

  # Iniciar el GenServer con una cola vacía
  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Función de callback para iniciar el estado del GenServer
  def init(queue) do
    {:ok, queue}
  end

  # Función para agregar un artículo a la cola de moderación
  def enqueue(article_id) do
    GenServer.cast(__MODULE__, {:enqueue, article_id})
  end

  # Función para obtener el primer artículo de la cola
  def dequeue do
    GenServer.call(__MODULE__, :dequeue)
  end

  # Callback para manejar la inserción en la cola
  def handle_cast({:enqueue, article_id}, queue) do
    {:noreply, [article_id | queue]}  # Agregar al frente de la cola
  end

  # Callback para manejar la extracción de la cola
  def handle_call(:dequeue, _from, [article_id | queue]) do
    {:reply, article_id, queue}  # Retornar el primer artículo y actualizar la cola
  end

  def handle_call(:dequeue, _from, []) do
    {:reply, nil, []}  # Si la cola está vacía, devolver nil
  end
end
