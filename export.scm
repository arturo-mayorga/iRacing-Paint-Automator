; This script is written in Scheme for use with GIMP. It automates the process of exporting paint files for iRacing.
; The script defines functions to hide layers, check if a layer belongs to a specific driver, and control visibility of spec layers.
; It also includes the main export-paint function which loads an image, configures driver-specific layers, merges visible layers, 
; and saves the final image. The script then exports paint files for multiple drivers.

; hide-branch: Recursively hides layers in a given list.
; string-starts-with: Checks if one string starts with another.
; is-driver-specific-layer: Determines if a layer is specific to a driver.
; is-layer-owned-by-driver: Checks if a layer belongs to a specific driver.
; set-spec-layer-visible: Sets the visibility of the spec layer.
; show-driver: Shows layers specific to a given driver and hides others.
; export-paint: Main function to export the paint file for a given driver.

(define hide-branch
  (lambda (layers)
    (let ( (count (car layers))
           (layer_array (cadr layers))
           )
      (let loop ((i 0))
        (unless (= i count)
                (let ( (item (aref layer_array i)) )
                   ; (gimp-message (car (gimp-item-get-name item)))
                  (if ( = TRUE (car (gimp-item-is-group item)) )
                      ( hide-branch (gimp-item-get-children item) )
                      ) ; if

                  ( gimp-item-set-visible item FALSE )
                  

                  (loop (+ i 1))
                  ) ; let
                ) ; unless
        ) ; let
      ) ; let
    ) ; lambda
  ) ; hide-branch


(define (string-starts-with str_a str_b)
    (let 
        (
            (len_a (string-length str_a))
            (len_b (string-length str_b))
        )

        (if (> len_b len_a)
            
            (= 1 2) ;; return false 
            
            (if (string=? (substring str_a 0 len_b) str_b)
                (begin
                    ; (gimp-message "starts with")
                    ; (gimp-message (substring str_a 0 len_b))
                    (= 1 1))
                (begin
                    ; (gimp-message "does not start with")
                    ; (gimp-message (substring str_a 0 len_b))
                    (= 1 2))
            )
        )
    )
)

(define (is-driver-specific-layer layer_name)
    (let* 
        (
            (driver_layer_prefix "driver_")
        )

        (if (string-starts-with layer_name driver_layer_prefix)
            (= 1 1)
            (= 1 2)
        )
    )
)

(define (is-layer-owned-by-driver layer_name driver_name)
    (let* 
        (
            (driver_layer_prefix "driver_")
            (driver_name_layer_prefix (string-append driver_layer_prefix driver_name)) ;; example "driver_mayorga"
        )

        (if (string-starts-with layer_name driver_name_layer_prefix)
            (= 1 1)
            (= 1 2)
        )
    )
)

(define set-spec-layer-visible
    (lambda (layers is_visible)
        (let ( 
                (count (car layers))
                (layer_array (cadr layers))
                (spec_layer_name "Custom Spec Map")
            )
            (let loop ((i 0))
                (unless (= i count)
                    (let* ( 
                            (item (aref layer_array i)) 
                            (layer_name (car (gimp-item-get-name item)))
                        )

                        (if (string=? layer_name spec_layer_name)
                            (begin
                                (gimp-item-set-visible item is_visible)
                            )
                        )

                        (loop (+ i 1))
                    ) ; let
                ) ; unless
            ) ; let
        ) ; let
    )
)

(define show-driver
    (lambda (layers driver_name)
        (let ( 
                (count (car layers))
                (layer_array (cadr layers))
            )
            (let loop ((i 0))
                (unless (= i count)
                    (let* ( 
                            (item (aref layer_array i)) 
                            (layer_name (car (gimp-item-get-name item)))
                        )

                        (if (is-driver-specific-layer layer_name)
                            (if (is-layer-owned-by-driver layer_name driver_name)
                                (begin
                                    ; (gimp-message layer_name)
                                    ; (gimp-message "driver layer belongs to driver")
                                    (gimp-item-set-visible item TRUE)
                                )
                                (begin
                                    ; (gimp-message layer_name)
                                    ; (gimp-message "driver layer does not belong to driver")
                                    (gimp-item-set-visible item FALSE)
                                )
                            )
                        )

                        (if ( = TRUE (car (gimp-item-is-group item)) )
                            ( show-driver (gimp-item-get-children item) driver_name)
                        ) ; if

                        (loop (+ i 1))
                    ) ; let
                ) ; unless
            ) ; let
        ) ; let
    ) ; lambda
) ; show-driver

(define (export-paint filename driver_name out_filename show_spec)

    (let
        (
            (image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
        )

        (gimp-message (string-append "exporting: " out_filename))

        (gimp-message "    configuring driver layers")
        (show-driver (gimp-image-get-layers image) driver_name)

        (gimp-message "    configuring spec layers")
        (set-spec-layer-visible (gimp-image-get-layers image) show_spec)

        (let
            (
                (drawable (car (gimp-image-merge-visible-layers image CLIP-TO-IMAGE)))
            )

            (gimp-message "    saving file")
            (gimp-file-save RUN-NONINTERACTIVE image drawable out_filename out_filename)
        )

        (gimp-message "    done...")
        (gimp-image-delete image)
    )
)

(gimp-message "start----")

(export-paint "paint_template.xcf" "firstDriver" "firstDriver.tga" FALSE)
(export-paint "paint_template.xcf" "firstDriver" "firstDriver_spec.tga" TRUE)

(export-paint "paint_template.xcf" "secondDriver" "secondDriver.tga" FALSE)
(export-paint "paint_template.xcf" "secondDriver" "secondDriver_spec.tga" TRUE)

(gimp-message "done----")

(gimp-quit 0)

; inspired by:
; https://github.com/an6688/SeniorProject/blob/ef096fd91ee83939eb2e3ad38e8a1a8e0b9595cd/SeniorProject/Assets/sparkle/common.scm#L55
; https://github.com/daretzkynmcg/gimp/blob/ffcde7400f402728373ff6579947c6ffe87d1a5e/registry.gimp.org/files/SpriteSheetGroups.scm#L33
; https://github.com/j-jorge/pack-my-sprites/blob/88aa3f0e538568bb0a03ce1a384b869fa7675867/modules/generators/scripts/common.scm#L127
; https://github.com/dchest/tinyscheme/blob/master/Manual.txt