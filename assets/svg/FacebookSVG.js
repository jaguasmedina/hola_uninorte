import React from 'react'
import Svg, { Path } from 'react-native-svg'

export const FacebookSVG = props => {
    let color = props.color ? props.color : "#FFFFFF";
    return (
        <Svg id="prefix__Layer_1" x={0} y={0} viewBox="0 0 500 500" xmlSpace="preserve"
        {...props}>
            <Path fill={color} d="M247.21,89.65C155.79,89.65,81.42,164,81.42,255.44s74.37,165.79,165.79,165.79S413,346.85,413,255.44,338.63,89.65,247.21,89.65Zm41.23,171.62h-27v96.14h-40V261.27h-19v-34h19v-22c0-15.74,7.48-40.34,40.33-40.34l29.62.12v33H270c-3.5,0-8.47,1.75-8.47,9.25v20h30.45Z" />
        </Svg>
    )
}
