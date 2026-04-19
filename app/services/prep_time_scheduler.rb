# app/services/prep_time_scheduler.rb
class PrepTimeScheduler
  DEFAULT_STATIONS = 2

  def initialize(menu, stations: DEFAULT_STATIONS)
    @menu = menu
    @stations = stations
  end

  def schedule(items)
    loads = initialize_stations

    items.each do |item|
      assign_to_least_loaded_station(loads, item)
    end

    format_schedule(loads)
  end

  private

  def initialize_stations
    (1..@stations).map { |id| [ id, 0 ] }.to_h
  end

  def assign_to_least_loaded_station(loads, item)
    prep_time = line_prep(item)
    station_id = loads.min_by { |_, load| load }.first
    loads[station_id] += prep_time
  end

  def line_prep(item)
    menu_item = @menu.find(item[:item_id])
    menu_item[:prep_seconds] * item[:qty]
  end

  def format_schedule(loads)
    loads.to_a.sort_by { |(_, time)| -time }
  end
end
