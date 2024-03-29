import React from 'react'
import Svg, { G, Path } from 'react-native-svg'
/* SVGR has dropped some elements not supported by react-native-svg: style */

export const DownloadSVG = props => {
    let color = props.color ? props.color : "#FFFFFF";
    return (
        <Svg id="prefix__Layer_1" x={0} y={0} viewBox="0 0 98.94 87" xmlSpace="preserve" {...props} >
            <G>
                <G>
                    <Path fill={color} d="M60.52,85.98l-15.18-15.3c-2.17-2.18-0.61-5.9,2.47-5.88l3.45,0.01l0.1-25.25c0.01-1.91,1.56-3.45,3.47-3.44
                        l16.67,0.07c1.91,0.01,3.45,1.56,3.44,3.47l-0.1,25.25l3.45,0.01c3.08,0.01,4.6,3.74,2.42,5.9L65.4,86
                        C64.05,87.34,61.86,87.33,60.52,85.98z"/>
                </G>
                <Path fill={color} d="M82.41,58.59l-66.02-0.27C7.32,58.28-0.04,50.88,0,41.82c0.03-7.03,4.59-13.28,11.21-15.5
                    c2.28-6.59,8.58-11.1,15.61-11.07l4.04,0.02C35.95,5.78,45.67-0.04,56.48,0C71.3,0.06,83.63,11.35,85.13,25.94
                    c7.88,1.28,13.84,8.18,13.81,16.27C98.9,51.28,91.49,58.62,82.41,58.59z M26.81,18.45c-5.9-0.02-11.15,3.92-12.78,9.59l-0.25,0.86
                    l-0.87,0.24c-5.69,1.58-9.68,6.79-9.7,12.68C3.18,49.13,9.1,55.08,16.4,55.11l66.02,0.27c7.3,0.03,13.27-5.88,13.3-13.18
                    c0.03-6.89-5.34-12.7-12.22-13.23l-1.4-0.11l-0.08-1.4C81.27,13.92,70.04,3.26,56.46,3.21c-9.9-0.04-18.78,5.47-23.18,14.37
                    l-0.44,0.9L26.81,18.45z"/>
            </G>
        </Svg>
    )
}