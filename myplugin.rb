require 'sketchup.rb'

Sketchup.send_action "showRubyPanel:"

UI.menu("PlugIns").add_item("Draw stairs") do
    UI.messagebox("I'm about to draw stairs!")

    draw_stairs()
end

def p2(x, y)
    { :x => x, :y => y }
end

@stairs = {
    :stairs => 10,
    :rise => 8,
    :run => 12,
    :width => 100,
    :thickness => 3,
    :rotation => 0.1,
    :displace => 12
}

def draw_stairs
    rise = @stairs[:rise]
    run = @stairs[:run]
    width = @stairs[:width]
    thickness = @stairs[:thickness]
    displace = @stairs[:displace]

    model = Sketchup.active_model
    entities = model.entities

    trans = Geom::Transformation.new

    rot = Geom::Transformation.rotation(Geom::Point3d.new(0, 0, 0), Geom::Vector3d.new(0, 0, 1), @stairs[:rotation])

    for step in 1..@stairs[:stairs] do
        z = rise * step

        pt1 = Geom::Point3d.new(0, displace * step, z).transform(trans)
        pt2 = Geom::Point3d.new(width, displace * step, z).transform(trans)
        pt3 = Geom::Point3d.new(width, displace * step + run, z).transform(trans)
        pt4 = Geom::Point3d.new(0, displace * step + run, z).transform(trans)
        
        new_face = entities.add_face(pt1, pt2, pt3, pt4)
        new_face.pushpull(thickness)

        trans *= rot
    end
end
