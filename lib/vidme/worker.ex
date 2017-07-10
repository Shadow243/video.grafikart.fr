defmodule Vidme.Worker do
  @moduledoc """
  Worker responsable de l'envoie d'une vidéo sur vidme
  """

  require Logger

  use Toniq.Worker, max_concurrency: 1

  alias VideoGrafikart.Tutoriel
  alias VideoGrafikart.Repo

  @doc """
  Gère l'envoie d'une vidéo sur vidme
  """
  @spec perform(%VideoGrafikart.Tutoriel{}):: atom
  def perform(tutoriel) do
    Logger.info("...Sending tutoriel " <> tutoriel.name)
    {:ok, params} = Vidme.API.upload(%{
      title: Tutoriel.title(tutoriel),
      description: Tutoriel.description(tutoriel),
      file: Tutoriel.video_path(tutoriel),
      thumbnail: Tutoriel.thumbnail_path(tutoriel)
    })
    Repo.update(Tutoriel.changeset(tutoriel, params))
    Logger.info("Finished Sending " <> tutoriel.name)
  end

end
