import React from 'react'
import Svg, { G, Path } from 'react-native-svg'

export const UploadSVG = props => {
    let color = props.color ? props.color : "#FFF";
    return (
        <Svg id="prefix__Layer_1" x={0} y={0} viewBox="0 0 96.9 87" xmlSpace="preserve" {...props} >
            <G>
                <G>
                    <Path fill={color} d="M64.87,28.31L79.74,43.3c2.12,2.14,0.6,5.78-2.41,5.76l-3.38-0.01l-0.1,34.58c-0.01,1.87-1.53,3.38-3.4,3.37
                        l-16.33-0.07c-1.87-0.01-3.38-1.53-3.37-3.4l0.1-34.58l-3.38-0.01c-3.01-0.01-4.51-3.66-2.37-5.78l14.99-14.87
                        C61.41,26.98,63.55,26.99,64.87,28.31z"/>
                </G>
                <Path fill={color} d="M80.72,57.45l-64.66-0.26C7.17,57.16-0.04,49.9,0,41.01c0.03-6.89,4.5-13.02,10.98-15.2
                    c2.23-6.46,8.4-10.88,15.29-10.86l3.96,0.02C35.21,5.67,44.73-0.04,55.31,0c14.52,0.06,26.6,11.13,28.06,25.44
                    c7.72,1.26,13.56,8.02,13.52,15.96C96.87,50.29,89.61,57.49,80.72,57.45z M26.26,18.1c-5.78-0.02-10.92,3.84-12.51,9.4l-0.24,0.85
                    l-0.85,0.24c-5.57,1.55-9.48,6.66-9.5,12.44c-0.03,7.15,5.77,13,12.92,13.03l64.66,0.26c7.15,0.03,13-5.77,13.03-12.92
                    c0.03-6.75-5.23-12.45-11.97-12.97l-1.37-0.11l-0.08-1.37C79.6,13.65,68.6,3.2,55.3,3.15c-9.7-0.04-18.4,5.36-22.7,14.09
                    l-0.43,0.88L26.26,18.1z"/>
            </G>
        </Svg>
    )
}