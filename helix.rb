require 'sketchup.rb'

Sketchup.send_action "showRubyPanel:"

UI.menu("PlugIns").add_item("Draw helix") do
    draw_helix()
end

@helix = {
    :steps => 100,
    :rise => 4,
    :radius => 100,
    :rotation => 0.05
}

def draw_helix()
    steps = @helix[:steps]
    rise = @helix[:rise]
    radius = @helix[:radius]
    rotation = @helix[:rotation]

    model = Sketchup.active_model
    entities = model.entities

    trans = Geom::Transformation.new

    rot = Geom::Transformation.rotation(Geom::Point3d.new(0, 0, 0), Geom::Vector3d.new(0, 0, 1), rotation)

    last_points = [Geom::Point3d.new(0, 0, 0), Geom::Point3d.new(radius, 0, 0), Geom::Point3d.new(0, 0, -rise), Geom::Point3d.new(radius, 0, -rise)]

    for step in 1..steps do
        z = rise * step
        trans *= rot

        pt1 = Geom::Point3d.new(0, 0, z).transform(trans)
        pt2 = Geom::Point3d.new(radius, 0, z).transform(trans)
        pt3 = Geom::Point3d.new(pt1.x, pt1.y, z - rise)
        pt4 = Geom::Point3d.new(pt2.x, pt2.y, z - rise)
        
        
        new_face = entities.add_face(pt1, last_points[0], pt2)
        new_face = entities.add_face(last_points[0], last_points[1], pt2)
        new_face = entities.add_face(pt3, pt4, last_points[2])
        new_face = entities.add_face(last_points[2], pt4, last_points[3])
        new_face = entities.add_face(pt2, last_points[1], last_points[3], pt4)

        last_points = [pt1, pt2, pt3, pt4]
    end
end
