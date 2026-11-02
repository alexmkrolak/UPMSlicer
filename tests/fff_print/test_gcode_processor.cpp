#include <catch2/catch_all.hpp>

#include "libslic3r/GCode/GCodeProcessor.hpp"
#include "libslic3r/PrintConfig.hpp"

#include <array>
#include <cmath>
#include <vector>

using namespace Slic3r;
using Catch::Matchers::WithinAbs;

namespace {

class BBLPrinterFlagRestorer
{
public:
    BBLPrinterFlagRestorer() : m_previous(GCodeProcessor::s_IsBBLPrinter)
    {
        GCodeProcessor::s_IsBBLPrinter = false;
    }

    ~BBLPrinterFlagRestorer() { GCodeProcessor::s_IsBBLPrinter = m_previous; }

private:
    bool m_previous;
};

void run_processor(GCodeProcessor& processor, const char* gcode)
{
    BBLPrinterFlagRestorer restore_flag;

    FullPrintConfig config;
    config.gcode_flavor.value = gcfMarlinFirmware;
    config.filament_diameter.values = {1.75};

    processor.reset();
    processor.initialize_result_moves();
    processor.apply_config(config);
    processor.initialize("gcode_processor_test.gcode");
    processor.process_buffer(gcode);
    processor.finalize(false);
}

std::vector<const GCodeProcessorResult::MoveVertex*> extrusion_moves(const GCodeProcessorResult& result)
{
    std::vector<const GCodeProcessorResult::MoveVertex*> moves;
    for (const GCodeProcessorResult::MoveVertex& move : result.moves)
        if (move.type == EMoveType::Extrude && move.delta_extruder > 0.0f)
            moves.push_back(&move);
    return moves;
}

} // namespace

TEST_CASE("Explicit toolpath widths remain constant across variable layer heights", "[GCodeProcessor][Regression]")
{
    const char* gcode =
        "M83\n"
        ";TYPE:Outer wall\n"
        ";WIDTH:8\n"
        ";HEIGHT:3\n"
        "G1 X10 Y0 Z3 E1 F600\n"
        ";HEIGHT:1\n"
        "G1 X20 Y0 Z4 E1\n"
        ";HEIGHT:0.5\n"
        "G1 X30 Y0 Z4.5 E1\n";

    GCodeProcessor processor;
    run_processor(processor, gcode);
    const std::vector<const GCodeProcessorResult::MoveVertex*> moves = extrusion_moves(processor.get_result());

    const std::array<double, 3> expected_heights = {3.0, 1.0, 0.5};
    REQUIRE_FALSE(moves.empty());
    for (const GCodeProcessorResult::MoveVertex* move : moves)
        CHECK_THAT(move->width, WithinAbs(8.0, 1e-5));

    for (double expected_height : expected_heights) {
        bool found = false;
        for (const GCodeProcessorResult::MoveVertex* move : moves)
            if (std::abs(move->height - expected_height) < 1e-5) {
                found = true;
                break;
            }
        CHECK(found);
    }
}

TEST_CASE("Inferred toolpath widths retain the preview artifact clamp", "[GCodeProcessor][Regression]")
{
    const char* gcode =
        "M83\n"
        ";TYPE:Outer wall\n"
        ";HEIGHT:0.5\n"
        "G1 X10 Y0 Z0.5 E100 F600\n";

    GCodeProcessor processor;
    run_processor(processor, gcode);
    const std::vector<const GCodeProcessorResult::MoveVertex*> moves = extrusion_moves(processor.get_result());

    REQUIRE(moves.size() == 1);
    CHECK_THAT(moves.front()->height, WithinAbs(0.5, 1e-5));
    CHECK_THAT(moves.front()->width, WithinAbs(2.0, 1e-5));
}
