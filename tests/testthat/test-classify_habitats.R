testthat::context("test-classify_habitats")

testthat::test_that("classify_habitats returns n classes", {

  landscape_classified <- shar::classify_habitats(raster = shar::landscape,
                                                  classes = 3)

  present_classes <- length(unique(raster::values(landscape_classified)))

  testthat::expect_equal(present_classes, expected = 3)
})